// Read the exact eBOOK build and optionally associate it with the existing owner group.
// Never print tokens, tester identities or raw API responses.
import CryptoKit
import Foundation

struct APIError: Error {}

func base64URL(_ data: Data) -> String {
    data.base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}

func token(key: P256.Signing.PrivateKey, keyID: String, issuerID: String) throws -> String {
    let now = Int(Date().timeIntervalSince1970)
    let header: [String: Any] = ["alg": "ES256", "kid": keyID, "typ": "JWT"]
    let claims: [String: Any] = [
        "iss": issuerID, "iat": now, "exp": now + 600, "aud": "appstoreconnect-v1"
    ]
    let body = base64URL(try JSONSerialization.data(withJSONObject: header)) + "." +
        base64URL(try JSONSerialization.data(withJSONObject: claims))
    let signature = try key.signature(for: Data(body.utf8))
    return body + "." + base64URL(signature.rawRepresentation)
}

func get(_ path: String, queries: [URLQueryItem], bearer: String) throws -> [[String: Any]] {
    var url = URLComponents(string: "https://api.appstoreconnect.apple.com/v1/" + path)!
    url.queryItems = queries
    var request = URLRequest(url: url.url!)
    request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
    let semaphore = DispatchSemaphore(value: 0)
    var responseData: Data?
    var response: URLResponse?
    var requestError: Error?
    URLSession.shared.dataTask(with: request) { data, result, error in
        responseData = data
        response = result
        requestError = error
        semaphore.signal()
    }.resume()
    guard semaphore.wait(timeout: .now() + 30) == .success,
          requestError == nil,
          let http = response as? HTTPURLResponse,
          http.statusCode == 200,
          let data = responseData,
          let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let items = json["data"] as? [[String: Any]] else {
        throw APIError()
    }
    return items
}

func addBuild(_ buildID: String, to groupID: String, bearer: String) throws {
    guard UUID(uuidString: buildID) != nil, UUID(uuidString: groupID) != nil else { throw APIError() }
    let url = URL(string: "https://api.appstoreconnect.apple.com/v1/betaGroups/" + groupID + "/relationships/builds")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.timeoutInterval = 30
    request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: ["data": [["type": "builds", "id": buildID]]])
    let semaphore = DispatchSemaphore(value: 0)
    var status = 0
    var failed = false
    URLSession.shared.dataTask(with: request) { _, response, error in
        status = (response as? HTTPURLResponse)?.statusCode ?? 0
        failed = error != nil
        semaphore.signal()
    }.resume()
    guard semaphore.wait(timeout: .now() + 35) == .success, !failed, status == 204 else { throw APIError() }
}

func enableExistingOwnerGroup(_ build: [String: Any], appID: String, groupID: String, bearer: String) throws {
    guard UUID(uuidString: groupID) != nil,
          let buildID = build["id"] as? String,
          let attributes = build["attributes"] as? [String: Any],
          attributes["processingState"] as? String == "VALID",
          attributes["buildAudienceType"] as? String == "INTERNAL_ONLY" else { throw APIError() }
    let groups = try get("apps/" + appID + "/betaGroups", queries: [URLQueryItem(name: "limit", value: "200")], bearer: bearer)
    guard let group = groups.first(where: { $0["id"] as? String == groupID }),
          let settings = group["attributes"] as? [String: Any],
          settings["name"] as? String == "Owner iPhone",
          settings["isInternalGroup"] as? Bool == true,
          settings["hasAccessToAllBuilds"] as? Bool == false,
          settings["publicLinkEnabled"] as? Bool != true else { throw APIError() }
    let path = "betaGroups/" + groupID + "/builds"
    let query = [URLQueryItem(name: "limit", value: "200")]
    let existing = try get(path, queries: query, bearer: bearer)
    if !existing.contains(where: { $0["id"] as? String == buildID }) {
        try addBuild(buildID, to: groupID, bearer: bearer)
    }
    let readback = try get(path, queries: query, bearer: bearer)
    guard readback.contains(where: { $0["id"] as? String == buildID }) else { throw APIError() }
    print("EBOOK_OWNER_GROUP_ASSOCIATION_VERIFIED")
}

let args = CommandLine.arguments
let once = args.count == 4 && args[3] == "--once"
guard (args.count == 3 || once),
      let keyID = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_KEY_ID"],
      let issuerID = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_ISSUER_ID"] else {
    print("EBOOK_PROCESSING_STATUS_NOT_VERIFIED configuration")
    exit(1)
}

do {
    let key = try P256.Signing.PrivateKey(pemRepresentation: String(contentsOfFile: args[1], encoding: .utf8))
    let apps = try get("apps", queries: [
        URLQueryItem(name: "filter[bundleId]", value: "com.zhangsfish.ebook"),
        URLQueryItem(name: "limit", value: "2")
    ], bearer: token(key: key, keyID: keyID, issuerID: issuerID))
    guard apps.count == 1, let appID = apps.first?["id"] as? String else { throw APIError() }

    // Apple's upload acceptance and build processing are separate events.
    let attempts = once ? 1 : 30
    for attempt in 0..<attempts {
        let builds = try get("builds", queries: [
            URLQueryItem(name: "filter[app]", value: appID),
            URLQueryItem(name: "filter[version]", value: args[2]),
            URLQueryItem(name: "limit", value: "2")
        ], bearer: token(key: key, keyID: keyID, issuerID: issuerID))
        if let item = builds.first,
           let attributes = item["attributes"] as? [String: Any],
           let state = attributes["processingState"] as? String {
            if state == "VALID" {
                guard builds.count == 1,
                      attributes["version"] as? String == args[2],
                      attributes["buildAudienceType"] as? String == "INTERNAL_ONLY",
                      attributes["expired"] as? Bool == false,
                      let buildID = item["id"] as? String else { throw APIError() }
                print("EBOOK_PROCESSING_STATUS_VALID build=" + args[2])
                print("EBOOK_BUILD_AUDIENCE_INTERNAL_ONLY")
                if let groupID = ProcessInfo.processInfo.environment["EBOOK_OWNER_GROUP_ID"] {
                    print("EBOOK_OWNER_GROUP_ASSOCIATION_START")
                    try enableExistingOwnerGroup(item, appID: appID, groupID: groupID,
                        bearer: token(key: key, keyID: keyID, issuerID: issuerID))
                } else {
                    throw APIError()
                }
                // Read only: group linkage alone is not an installability result.
                // Official collection: /v1/buildBetaDetails?filter[build]=<id>.
                print("EBOOK_INSTALLABILITY_QUERY_START")
                let details = try get("buildBetaDetails", queries: [
                    URLQueryItem(name: "filter[build]", value: buildID),
                    URLQueryItem(name: "fields[buildBetaDetails]", value: "internalBuildState"),
                    URLQueryItem(name: "limit", value: "2")
                ], bearer: token(key: key, keyID: keyID, issuerID: issuerID))
                if details.count == 1,
                   let detail = details.first?["attributes"] as? [String: Any],
                   detail["internalBuildState"] as? String == "IN_BETA_TESTING" {
                    print("EBOOK_INTERNAL_STATE_IN_BETA_TESTING")
                    print("EBOOK_TESTFLIGHT_AVAILABLE build=" + args[2])
                    exit(0)
                }
            }
            if state == "FAILED" || state == "INVALID" {
                print("EBOOK_PROCESSING_STATUS_" + state + " build=" + args[2])
                exit(2)
            }
        }
        if once {
            if builds.isEmpty {
                print("EBOOK_BUILD_NOT_FOUND build=" + args[2])
                exit(3)
            }
            print("EBOOK_BUILD_EXISTS_NOT_YET_INSTALLABLE build=" + args[2])
            exit(4)
        }
        if attempt < attempts - 1 { Thread.sleep(forTimeInterval: 30) }
    }
    print("EBOOK_PROCESSING_STATUS_PENDING build=" + args[2])
    exit(1)
} catch {
    print("EBOOK_PROCESSING_STATUS_NOT_VERIFIED api_query_failed")
    exit(1)
}
