// Read-only exact-build queries. Never print bearer tokens, keys or raw API bodies.
import CryptoKit
import Foundation

struct RCAPIError: Error { let code: String }

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
    request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    let semaphore = DispatchSemaphore(value: 0)
    var responseData: Data?
    var response: URLResponse?
    var requestError: Error?
    URLSession.shared.dataTask(with: request) { data, result, error in
        responseData = data; response = result; requestError = error; semaphore.signal()
    }.resume()
    guard semaphore.wait(timeout: .now() + 30) == .success, requestError == nil,
          let http = response as? HTTPURLResponse else { throw RCAPIError(code: "NETWORK_OR_TIMEOUT") }
    guard http.statusCode == 200 else { throw RCAPIError(code: "HTTP_" + String(http.statusCode)) }
    guard let data = responseData,
          let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw RCAPIError(code: "RESPONSE_SHAPE")
    }
    return json
}

func write(_ safe: [String: Any], _ path: String) throws {
    let data = try JSONSerialization.data(withJSONObject: safe, options: [.prettyPrinted, .sortedKeys])
    try data.write(to: URL(fileURLWithPath: path), options: .atomic)
}

let args = CommandLine.arguments
guard args.count == 4, ["preflight", "poll", "once"].contains(args[2]),
      let keyID = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_KEY_ID"],
      let issuer = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_ISSUER_ID"] else {
    print("S05_RC_ASC_UNCONFIRMED configuration"); exit(1)
}

do {
    let key = try P256.Signing.PrivateKey(pemRepresentation: String(contentsOfFile: args[1], encoding: .utf8))
    let apps = try get("apps", [URLQueryItem(name: "filter[bundleId]", value: "com.zhangsfish.lectureasset"),
                              URLQueryItem(name: "limit", value: "2")], try bearer(key, keyID, issuer))
    guard let items = apps["data"] as? [[String: Any]], items.count == 1,
          let appID = items[0]["id"] as? String else { throw RCAPIError(code: "APP_NOT_UNIQUE") }
    let mode = args[2]
    let attempts = mode == "poll" ? 40 : 1
    for attempt in 0..<attempts {
        let response = try get("builds", [
            URLQueryItem(name: "filter[app]", value: appID),
            URLQueryItem(name: "filter[version]", value: "32.1"),
            URLQueryItem(name: "fields[builds]", value: "version,uploadedDate,minOsVersion,processingState,buildAudienceType,usesNonExemptEncryption,preReleaseVersion"),
            URLQueryItem(name: "include", value: "preReleaseVersion"),
            URLQueryItem(name: "fields[preReleaseVersions]", value: "version,platform"),
            URLQueryItem(name: "limit", value: "2")], try bearer(key, keyID, issuer))
        guard let builds = response["data"] as? [[String: Any]], builds.count <= 1 else {
            throw RCAPIError(code: "EXACT_BUILD_NOT_UNIQUE")
        }
        if let build = builds.first, let attributes = build["attributes"] as? [String: Any],
           let id = build["id"] as? String {
            let state = attributes["processingState"] as? String ?? "UNCONFIRMED"
            let audience = attributes["buildAudienceType"] as? String ?? "UNCONFIRMED"
            let included = response["included"] as? [[String: Any]] ?? []
            let versions = included.filter { $0["type"] as? String == "preReleaseVersions" }
            let version = (versions.first?["attributes"] as? [String: Any])?["version"] as? String ?? "UNCONFIRMED"
            let safe: [String: Any] = [
                "version": version, "build": "32.1", "buildID": id,
                "processingState": state, "buildAudienceType": audience,
                "uploadedDate": attributes["uploadedDate"] ?? NSNull(),
                "minOsVersion": attributes["minOsVersion"] ?? NSNull(),
                "usesNonExemptEncryption": attributes["usesNonExemptEncryption"] ?? NSNull(),
                "queryMode": mode, "queryDate": ISO8601DateFormatter().string(from: Date()),
                "appReview": "NOT_SUBMITTED_BY_THIS_WORKFLOW"]
            try write(safe, args[3])
            if mode == "preflight" { print("S05_RC_BUILD_ALREADY_EXISTS_NO_UPLOAD"); exit(2) }
            if audience == "INTERNAL_ONLY" || state == "FAILED" || state == "INVALID" {
                print("S05_RC_ASC_REJECTED state=" + state + " audience=" + audience); exit(1)
            }
            if state == "VALID" && audience == "APP_STORE_ELIGIBLE" {
                guard version == "0.1.0", attributes["version"] as? String == "32.1",
                      attributes["minOsVersion"] as? String == "18.0",
                      attributes["usesNonExemptEncryption"] as? Bool == false else {
                    throw RCAPIError(code: "VALID_BUILD_METADATA_MISMATCH")
                }
                print("S05_RC_ASC_VALID_APP_STORE_ELIGIBLE version=0.1.0 build=32.1"); exit(0)
            }
            print("S05_RC_ASC_PENDING state=" + state + " audience=" + audience)
        } else {
            try write(["version": "0.1.0", "build": "32.1", "processingState": "NOT_VISIBLE",
                       "buildAudienceType": "UNCONFIRMED", "queryMode": mode], args[3])
            if mode == "preflight" { print("S05_RC_BUILD_NUMBER_AVAILABLE"); exit(0) }
        }
        if attempt + 1 < attempts { Thread.sleep(forTimeInterval: 30) }
    }
    print("S05_RC_ASC_PROCESSING_OR_UNCONFIRMED build=32.1"); exit(3)
} catch let error as RCAPIError {
    print("S05_RC_ASC_UNCONFIRMED " + error.code); exit(1)
} catch {
    print("S05_RC_ASC_UNCONFIRMED PRIVATE_DETAIL_SUPPRESSED"); exit(1)
}
