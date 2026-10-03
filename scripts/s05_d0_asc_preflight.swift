// Read-only App Store Connect preflight for S05-D0.
// Uses the existing GitHub Actions App Store Connect API key.
// Never prints JWTs, private keys, raw API responses, account identity, tax or banking data.

import CryptoKit
import Foundation

struct PreflightError: Error, CustomStringConvertible {
    let description: String
}

struct HTTPStatusError: Error, CustomStringConvertible {
    let statusCode: Int
    let path: String
    var description: String { "ASC HTTP \(statusCode)" }
}

func base64URL(_ data: Data) -> String {
    data.base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
}

final class NoRedirect: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
let ascSession = URLSession(configuration: .ephemeral, delegate: NoRedirect(), delegateQueue: nil)

func makeToken(key: P256.Signing.PrivateKey, keyID: String, issuerID: String) throws -> String {
    let now = Int(Date().timeIntervalSince1970)
    let header: [String: Any] = ["alg": "ES256", "kid": keyID, "typ": "JWT"]
    let claims: [String: Any] = [
        "iss": issuerID,
        "iat": now,
        "exp": now + 600,
        "aud": "appstoreconnect-v1"
    ]
    let unsigned = base64URL(try JSONSerialization.data(withJSONObject: header)) + "." +
        base64URL(try JSONSerialization.data(withJSONObject: claims))
    let signature = try key.signature(for: Data(unsigned.utf8))
    return unsigned + "." + base64URL(signature.rawRepresentation)
}

func requestJSON(_ url: URL, bearer: String) throws -> [String: Any] {
    guard url.scheme == "https", url.host == "api.appstoreconnect.apple.com" else {
        throw PreflightError(description: "Unexpected ASC origin")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer " + bearer, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    let semaphore = DispatchSemaphore(value: 0)
    var responseData: Data?
    var response: URLResponse?
    var requestError: Error?

    ascSession.dataTask(with: request) { data, result, error in
        responseData = data
        response = result
        requestError = error
        semaphore.signal()
    }.resume()

    guard semaphore.wait(timeout: .now() + 45) == .success else {
        throw PreflightError(description: "ASC request timed out")
    }
    if let requestError {
        throw PreflightError(description: "ASC transport failed code=\((requestError as NSError).code)")
    }
    guard let http = response as? HTTPURLResponse, let data = responseData else {
        throw PreflightError(description: "ASC response missing")
    }
    guard (200..<300).contains(http.statusCode) else {
        // Do not print raw response bodies. They can contain account-specific details.
        throw HTTPStatusError(statusCode: http.statusCode, path: url.path)
    }
    guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw PreflightError(description: "ASC returned unexpected JSON")
    }
    return object
}

func apiURL(_ path: String, queries: [URLQueryItem] = []) throws -> URL {
    guard var components = URLComponents(string: "https://api.appstoreconnect.apple.com/v1/" + path) else {
        throw PreflightError(description: "Invalid ASC path")
    }
    if !queries.isEmpty { components.queryItems = queries }
    guard let url = components.url else {
        throw PreflightError(description: "Invalid ASC URL")
    }
    return url
}

func get(_ path: String, queries: [URLQueryItem] = [], bearer: String) throws -> [String: Any] {
    try requestJSON(apiURL(path, queries: queries), bearer: bearer)
}

func dataArray(_ json: [String: Any]) -> [[String: Any]] {
    json["data"] as? [[String: Any]] ?? []
}

func dataObject(_ json: [String: Any]) -> [String: Any]? {
    json["data"] as? [String: Any]
}

func attributes(_ item: [String: Any]) -> [String: Any] {
    item["attributes"] as? [String: Any] ?? [:]
}

func relatedID(_ item: [String: Any], relationship: String) -> String? {
    guard
        let relationships = item["relationships"] as? [String: Any],
        let rel = relationships[relationship] as? [String: Any],
        let data = rel["data"] as? [String: Any]
    else { return nil }
    return data["id"] as? String
}

func relatedURL(_ item: [String: Any], relationship: String) -> URL? {
    guard
        let relationships = item["relationships"] as? [String: Any],
        let rel = relationships[relationship] as? [String: Any],
        let links = rel["links"] as? [String: Any],
        let related = links["related"] as? String
    else { return nil }
    return URL(string: related)
}

func paginatedData(startURL: URL, bearer: String) throws -> [[String: Any]] {
    var current: URL? = startURL
    var all: [[String: Any]] = []
    var seen = Set<String>()

    while let url = current {
        guard seen.insert(url.absoluteString).inserted else {
            throw PreflightError(description: "ASC pagination loop")
        }
        let json = try requestJSON(url, bearer: bearer)
        all.append(contentsOf: dataArray(json))
        if
            let links = json["links"] as? [String: Any],
            let next = links["next"] as? String,
            !next.isEmpty
        {
            current = URL(string: next)
        } else {
            current = nil
        }
    }
    return all
}

func JSONSafe(_ value: Any?) -> Any {
    guard let value else { return NSNull() }
    switch value {
    case is String, is NSNumber, is NSNull:
        return value
    case let array as [Any]:
        return array.map { JSONSafe($0) }
    case let dict as [String: Any]:
        return dict.mapValues { JSONSafe($0) }
    default:
        return String(describing: value)
    }
}

let args = CommandLine.arguments
guard args.count == 3 else {
    print("S05_D0_ASC_NOT_VERIFIED usage")
    exit(2)
}
guard
    let keyID = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_KEY_ID"],
    let issuerID = ProcessInfo.processInfo.environment["APP_STORE_CONNECT_ISSUER_ID"]
else {
    print("S05_D0_ASC_NOT_VERIFIED configuration")
    exit(2)
}

let keyPath = args[1]
let outputPath = args[2]
let bundleID = "com.zhangsfish.lectureasset"

do {
    let pem = try String(contentsOfFile: keyPath, encoding: .utf8)
    let key = try P256.Signing.PrivateKey(pemRepresentation: pem)
    let bearer = try makeToken(key: key, keyID: keyID, issuerID: issuerID)

    let appsJSON = try get("apps", queries: [
        URLQueryItem(name: "filter[bundleId]", value: bundleID),
        URLQueryItem(name: "fields[apps]", value: "name,bundleId,sku,primaryLocale,isOrEverWasMadeForKids"),
        URLQueryItem(name: "limit", value: "2")
    ], bearer: bearer)
    let apps = dataArray(appsJSON)
    guard apps.count == 1, let appID = apps.first?["id"] as? String else {
        throw PreflightError(description: "Expected exactly one ASC app for bundle id")
    }

    var output: [String: Any] = [
        "capturedAt": ISO8601DateFormatter().string(from: Date()),
        "bundleId": bundleID,
        "app": [
            "name": attributes(apps[0])["name"] ?? NSNull(),
            "primaryLocale": attributes(apps[0])["primaryLocale"] ?? NSNull(),
            "isOrEverWasMadeForKids": attributes(apps[0])["isOrEverWasMadeForKids"] ?? NSNull()
        ]
    ]

    // Region availability: GET only. contentStatuses surfaces App Store Connect
    // blockers such as ICP_NUMBER_MISSING / ICP_NUMBER_INVALID when Apple reports them.
    // A 404 is meaningful for a new app: the availability-v2 resource is not created
    // or not visible yet. Record that state instead of treating it as an API failure.
    var regions: [String: Any] = [:]
    do {
        let availabilityJSON = try get("apps/\(appID)/appAvailabilityV2", bearer: bearer)
        guard let availability = dataObject(availabilityJSON) else {
            throw PreflightError(description: "App availability response missing")
        }

        var territoryItems: [[String: Any]] = []
        if let url = relatedURL(availability, relationship: "territoryAvailabilities") {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var queryItems = components?.queryItems ?? []
            queryItems.append(URLQueryItem(name: "fields[territoryAvailabilities]", value: "available,contentStatuses,territory"))
            queryItems.append(URLQueryItem(name: "limit", value: "50"))
            components?.queryItems = queryItems
            if let pagedURL = components?.url {
                territoryItems = try paginatedData(startURL: pagedURL, bearer: bearer)
            }
        }

        for item in territoryItems {
            let code = relatedID(item, relationship: "territory") ?? ""
            guard code == "CHN" || code == "USA" else { continue }
            let attrs = attributes(item)
            regions[code] = [
                "available": attrs["available"] ?? NSNull(),
                "contentStatuses": attrs["contentStatuses"] ?? []
            ]
        }
        output["availabilityResource"] = "AVAILABLE"
    } catch let error as HTTPStatusError where error.statusCode == 404 {
        output["availabilityResource"] = "NOT_CREATED_OR_NOT_VISIBLE"
        print("S05_D0_ASC_AVAILABILITY resource=NOT_CREATED_OR_NOT_VISIBLE")
    }
    output["regions"] = regions

    // Older App Store Connect records can expose the legacy availableTerritories
    // relationship before AppAvailabilityV2 exists. Read it only as an additional
    // signal; it cannot expose the v2 contentStatuses/ICP status.
    do {
        let legacyJSON = try get("apps/\(appID)/availableTerritories", queries: [
            URLQueryItem(name: "limit", value: "200")
        ], bearer: bearer)
        let ids = Set(dataArray(legacyJSON).compactMap { $0["id"] as? String })
        output["legacyAvailableTerritories"] = [
            "read": "AVAILABLE",
            "CHN": ids.contains("CHN"),
            "USA": ids.contains("USA"),
            "count": ids.count
        ]
        print("S05_D0_ASC_LEGACY_AVAILABILITY CHN=\(ids.contains("CHN")) USA=\(ids.contains("USA")) count=\(ids.count)")
    } catch let error as HTTPStatusError where error.statusCode == 404 {
        output["legacyAvailableTerritories"] = ["read": "NOT_CREATED_OR_NOT_VISIBLE"]
        print("S05_D0_ASC_LEGACY_AVAILABILITY resource=NOT_CREATED_OR_NOT_VISIBLE")
    } catch {
        output["legacyAvailableTerritories"] = ["read": "UNAVAILABLE"]
        print("S05_D0_ASC_LEGACY_AVAILABILITY read=UNAVAILABLE")
    }

    // Territory catalog is read-only and answers whether CHN/USA are valid current
    // App Store territories independently of this app's own availability config.
    do {
        let catalogJSON = try get("territories", queries: [
            URLQueryItem(name: "limit", value: "200")
        ], bearer: bearer)
        let ids = Set(dataArray(catalogJSON).compactMap { $0["id"] as? String })
        output["storefrontCatalog"] = [
            "CHN": ids.contains("CHN"),
            "USA": ids.contains("USA"),
            "count": ids.count
        ]
        print("S05_D0_ASC_STOREFRONT_CATALOG CHN=\(ids.contains("CHN")) USA=\(ids.contains("USA")) count=\(ids.count)")
    } catch {
        output["storefrontCatalog"] = ["read": "UNAVAILABLE"]
        print("S05_D0_ASC_STOREFRONT_CATALOG read=UNAVAILABLE")
    }

    for code in ["CHN", "USA"] {
        if let region = regions[code] as? [String: Any] {
            let available = String(describing: region["available"] ?? "unknown")
            let statuses = (region["contentStatuses"] as? [String] ?? []).joined(separator: ",")
            print("S05_D0_ASC_REGION code=\(code) available=\(available) statuses=\(statuses.isEmpty ? "NONE" : statuses)")
        } else {
            print("S05_D0_ASC_REGION code=\(code) status=UNKNOWN_AVAILABILITY_NOT_CONFIGURED")
        }
    }

    // App-info and age-rating questionnaire state. Read only.
    let appInfosJSON = try get("apps/\(appID)/appInfos", queries: [
        URLQueryItem(name: "limit", value: "10")
    ], bearer: bearer)
    let appInfos = dataArray(appInfosJSON)
    var appInfoOutput: [[String: Any]] = []

    for info in appInfos {
        guard let infoID = info["id"] as? String else { continue }
        var infoResult: [String: Any] = [
            "state": attributes(info)["appStoreState"] ?? NSNull()
        ]

        do {
            let ratingJSON = try get("appInfos/\(infoID)/ageRatingDeclaration", bearer: bearer)
            if let rating = dataObject(ratingJSON) {
                infoResult["ageRatingDeclaration"] = attributes(rating).filter {
                    $0.value is Bool || $0.value is NSNull ||
                    ["NONE", "INFREQUENT_OR_MILD", "FREQUENT_OR_INTENSE", "SEVENTEEN_PLUS", "NO_OVERRIDE"].contains($0.value as? String ?? "")
                }
                infoResult["ageRatingDeclarationPresent"] = true
            }
        } catch {
            infoResult["ageRatingDeclarationRead"] = "UNAVAILABLE"
        }

        do {
            let locJSON = try get("appInfos/\(infoID)/appInfoLocalizations", queries: [
                URLQueryItem(name: "fields[appInfoLocalizations]", value: "locale,name,subtitle,privacyPolicyUrl,privacyChoicesUrl"),
                URLQueryItem(name: "limit", value: "50")
            ], bearer: bearer)
            infoResult["localizations"] = dataArray(locJSON).map { item in
                var result = attributes(item)
                return result
            }
        } catch {
            infoResult["localizationsRead"] = "UNAVAILABLE"
        }

        appInfoOutput.append(infoResult)
    }
    output["appInfos"] = appInfoOutput

    // Public build state only; never emit resource/account identifiers.
    do {
        let builds = try get("builds", queries: [
            URLQueryItem(name: "filter[app]", value: appID),
            URLQueryItem(name: "filter[version]", value: "30.1"),
            URLQueryItem(name: "limit", value: "10")
        ], bearer: bearer)
        output["acceptedBuild"] = dataArray(builds).map { item in
            attributes(item).filter { ["version", "processingState", "expired", "usesNonExemptEncryption", "buildAudienceType"].contains($0.key) }
        }
    } catch { output["acceptedBuildRead"] = "UNAVAILABLE" }

    // Current iOS App Store version state. Metadata writing is deliberately out of scope.
    do {
        let versionsJSON = try get("apps/\(appID)/appStoreVersions", queries: [
            URLQueryItem(name: "filter[platform]", value: "IOS"),
            URLQueryItem(name: "fields[appStoreVersions]", value: "platform,versionString,appVersionState,releaseType,reviewType"),
            URLQueryItem(name: "limit", value: "20")
        ], bearer: bearer)
        output["iosAppStoreVersions"] = dataArray(versionsJSON).map { item in
            var result = attributes(item)
            return result
        }
        var readiness: [[String: Any]] = []
        for version in dataArray(versionsJSON) {
            guard let id = version["id"] as? String else { continue }
            do {
                let localizations = try get("appStoreVersions/\(id)/appStoreVersionLocalizations", bearer: bearer)
                readiness += dataArray(localizations).map { item in
                    let values = attributes(item)
                    var result: [String: Any] = ["locale": values["locale"] ?? NSNull()]
                    for field in ["description", "keywords", "supportUrl", "promotionalText"] {
                        result[field + "Present"] = !(values[field] as? String ?? "").isEmpty
                    }
                    return result
                }
            } catch { readiness.append(["read": "UNAVAILABLE"]) }
        }
        output["versionMetadataReadiness"] = readiness
    } catch {
        output["iosAppStoreVersionsRead"] = "UNAVAILABLE"
    }

    let serialized = try JSONSerialization.data(
        withJSONObject: JSONSafe(output),
        options: [.prettyPrinted, .sortedKeys]
    )
    try serialized.write(to: URL(fileURLWithPath: outputPath), options: .atomic)

    print("S05_D0_ASC_PREFLIGHT_OK output=asc-preflight.json")
} catch {
    if let safe = error as? PreflightError { print("S05_D0_ASC_NOT_VERIFIED " + safe.description) }
    else if let safe = error as? HTTPStatusError { print("S05_D0_ASC_NOT_VERIFIED " + safe.description) }
    else { print("S05_D0_ASC_NOT_VERIFIED local_crypto_or_json_error") }
    exit(1)
}
