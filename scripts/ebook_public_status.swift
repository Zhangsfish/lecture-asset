// GET-only exact eBOOK public-build readback. No group or review mutations.
import CryptoKit
import Foundation

struct PublicAPIError: Error { let code: String }

func require(_ condition: Bool, _ code: String) throws {
    if !condition { throw PublicAPIError(code: code) }
}

func base64URL(_ data: Data) -> String {
    data.base64EncodedString().replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
}

func bearer(_ key: P256.Signing.PrivateKey, _ keyID: String, _ issuer: String) throws -> String {
    let now = Int(Date().timeIntervalSince1970)
    let header: [String: Any] = ["alg": "ES256", "kid": keyID, "typ": "JWT"]
    let claims: [String: Any] = ["iss": issuer, "iat": now, "exp": now + 600, "aud": "appstoreconnect-v1"]
    let text = base64URL(try JSONSerialization.data(withJSONObject: header)) + "." +
        base64URL(try JSONSerialization.data(withJSONObject: claims))
    return text + "." + base64URL(try key.signature(for: Data(text.utf8)).rawRepresentation)
}

func get(_ path: String, _ queries: [URLQueryItem], _ token: String) throws -> [String: Any] {
    var url = URLComponents(string: "https://api.appstoreconnect.apple.com/v1/" + path)!
    url.queryItems = queries
    var request = URLRequest(url: url.url!)
    request.timeoutInterval = 30
    request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    let semaphore = DispatchSemaphore(value: 0)
    var responseData: Data?
    var response: URLResponse?
    var requestError: Error?
    URLSession.shared.dataTask(with: request) { data, result, error in
        responseData = data; response = result; requestError = error; semaphore.signal()
    }.resume()
    guard semaphore.wait(timeout: .now() + 35) == .success, requestError == nil,
          let http = response as? HTTPURLResponse else { throw PublicAPIError(code: "NETWORK_OR_TIMEOUT") }
    guard http.statusCode == 200 else { throw PublicAPIError(code: "HTTP_" + String(http.statusCode)) }
    guard let data = responseData,
          let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw PublicAPIError(code: "RESPONSE_SHAPE")
    }
    return json
}

func publicBuildContract(_ response: [String: Any], _ buildNumber: String) throws -> Bool {
    guard let builds = response["data"] as? [[String: Any]], builds.count <= 1 else {
        throw PublicAPIError(code: "EXACT_BUILD_NOT_UNIQUE")
    }
    guard let build = builds.first else { return false }
    guard let attributes = build["attributes"] as? [String: Any] else {
        throw PublicAPIError(code: "BUILD_ATTRIBUTES_MISSING")
    }
    try require(attributes["version"] as? String == buildNumber, "BUILD_NUMBER_MISMATCH")
    let state = attributes["processingState"] as? String ?? "UNCONFIRMED"
    let audience = attributes["buildAudienceType"] as? String ?? "UNCONFIRMED"
    try require(!["FAILED", "INVALID"].contains(state), "PROCESSING_REJECTED")
    try require(audience != "INTERNAL_ONLY", "INTERNAL_ONLY_NOT_PUBLIC")
    if state != "VALID" || audience != "APP_STORE_ELIGIBLE" { return false }
    let relationships = build["relationships"] as? [String: Any]
    let preRelease = relationships?["preReleaseVersion"] as? [String: Any]
    let versionID = (preRelease?["data"] as? [String: Any])?["id"] as? String
    let included = response["included"] as? [[String: Any]] ?? []
    let versions = included.filter { $0["type"] as? String == "preReleaseVersions" && $0["id"] as? String == versionID }
    try require(versionID != nil && versions.count == 1, "MARKETING_VERSION_RELATIONSHIP_MISSING")
    let version = versions.first?["attributes"] as? [String: Any]
    try require(version?["version"] as? String == "1.0" && version?["platform"] as? String == "IOS",
                "MARKETING_VERSION_OR_PLATFORM_MISMATCH")
    try require(attributes["expired"] as? Bool == false, "BUILD_EXPIRED_OR_UNCONFIRMED")
    try require(attributes["minOsVersion"] as? String == "17.0", "MIN_OS_MISMATCH")
    try require(attributes["usesNonExemptEncryption"] as? Bool == false, "ENCRYPTION_UNCONFIRMED")
    return true
}

func selfTest() throws {
    let attributes: [String: Any] = ["version": "1.1", "processingState": "VALID",
        "buildAudienceType": "APP_STORE_ELIGIBLE", "expired": false,
        "minOsVersion": "17.0", "usesNonExemptEncryption": false]
    let relation: [String: Any] = ["preReleaseVersion": ["data": ["id": "synthetic-version"]]]
    let version: [String: Any] = ["type": "preReleaseVersions", "id": "synthetic-version",
        "attributes": ["version": "1.0", "platform": "IOS"]]
    func envelope(_ a: [String: Any], _ v: [String: Any]) -> [String: Any] {
        ["data": [["attributes": a, "relationships": relation]], "included": [v]]
    }
    let valid = try publicBuildContract(envelope(attributes, version), "1.1")
    let absent = try publicBuildContract(["data": [[String: Any]]()], "1.1")
    try require(valid, "SELF_TEST_VALID_REJECTED")
    try require(!absent, "SELF_TEST_ABSENT_ACCEPTED")
    var rejected = 0
    for (key, value) in [("buildAudienceType", "INTERNAL_ONLY" as Any),
                         ("version", "2.1" as Any), ("expired", true as Any),
                         ("minOsVersion", "18.0" as Any), ("usesNonExemptEncryption", true as Any),
                         ("processingState", "INVALID" as Any)] {
        var invalid = attributes; invalid[key] = value
        do { _ = try publicBuildContract(envelope(invalid, version), "1.1") }
        catch { rejected += 1 }
    }
    var wrongVersion = version; wrongVersion["attributes"] = ["version": "0.1.0", "platform": "IOS"]
    do { _ = try publicBuildContract(envelope(attributes, wrongVersion), "1.1") }
    catch { rejected += 1 }
    do { _ = try publicBuildContract(["data": [["attributes": attributes]]], "1.1") }
    catch { rejected += 1 }
    try require(rejected == 8, "SELF_TEST_INVALID_ACCEPTED")
    print("EBOOK_PUBLIC_STATUS_SELF_TEST_PASS negative_cases=8 synthetic_only=true")
}

let args = CommandLine.arguments
do {
    if args.count == 2 && args[1] == "--self-test" { try selfTest(); exit(0) }
    guard args.count == 4, ["preflight", "once", "poll"].contains(args[3]),
          args[2].range(of: #"^[1-9][0-9]*\.[1-9][0-9]*$"#, options: .regularExpression) != nil,
          let keyID = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_KEY_ID"],
          let issuer = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_ISSUER_ID"] else {
        throw PublicAPIError(code: "CONFIGURATION")
    }
    let key = try P256.Signing.PrivateKey(pemRepresentation: String(contentsOfFile: args[1], encoding: .utf8))
    let apps = try get("apps", [URLQueryItem(name: "filter[bundleId]", value: "com.zhangsfish.ebook"),
                               URLQueryItem(name: "limit", value: "2")], try bearer(key, keyID, issuer))
    guard let items = apps["data"] as? [[String: Any]], items.count == 1,
          let appID = items[0]["id"] as? String else { throw PublicAPIError(code: "APP_NOT_UNIQUE") }
    let attempts = args[3] == "poll" ? 40 : 1
    for attempt in 0..<attempts {
        let response = try get("builds", [URLQueryItem(name: "filter[app]", value: appID),
            URLQueryItem(name: "filter[version]", value: args[2]),
            URLQueryItem(name: "fields[builds]", value: "version,processingState,buildAudienceType,expired,minOsVersion,usesNonExemptEncryption,preReleaseVersion"),
            URLQueryItem(name: "include", value: "preReleaseVersion"),
            URLQueryItem(name: "fields[preReleaseVersions]", value: "version,platform"),
            URLQueryItem(name: "limit", value: "2")], try bearer(key, keyID, issuer))
        if args[3] == "preflight" {
            try require((response["data"] as? [[String: Any]])?.isEmpty == true, "BUILD_ALREADY_EXISTS_NO_UPLOAD")
            print("EBOOK_PUBLIC_BUILD_UNUSED build=" + args[2]); exit(0)
        }
        if try publicBuildContract(response, args[2]) {
            print("EBOOK_PUBLIC_ASC_VALID_APP_STORE_ELIGIBLE version=1.0 build=" + args[2]
                + " queryDate=" + ISO8601DateFormatter().string(from: Date())
                + " appReview=NOT_SUBMITTED_BY_THIS_WORKFLOW")
            exit(0)
        }
        if attempt + 1 < attempts { Thread.sleep(forTimeInterval: 30) }
    }
    print("EBOOK_PUBLIC_ASC_PENDING_OR_NOT_VISIBLE build=" + args[2]); exit(3)
} catch let error as PublicAPIError {
    print("EBOOK_PUBLIC_ASC_UNCONFIRMED " + error.code); exit(2)
} catch {
    print("EBOOK_PUBLIC_ASC_UNCONFIRMED PRIVATE_DETAIL_SUPPRESSED"); exit(2)
}
