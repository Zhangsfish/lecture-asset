// Explicit R2 ASC readback / existing-internal-group association only.
// Raw responses, authentication and reviewer contacts never leave memory.
import Foundation
import CryptoKit

struct SafeASCError: Error { let code: String }
let env = ProcessInfo.processInfo.environment
let args = CommandLine.arguments
guard args.count == 4, ["readback", "internal"].contains(args[2]),
      let keyID = env["APP_STORE_CONNECT_KEY_ID"], let issuer = env["APP_STORE_CONNECT_ISSUER_ID"] else {
    print("S05_R2_ASC_CONFIGURATION"); exit(1)
}
let configPath = "reports/S05/submission-closeout-2026-10-31/round-01/candidate.json"
var report: [String: Any] = ["queryDate": ISO8601DateFormatter().string(from: Date()),
    "operation": args[2], "appReviewSubmitted": false, "storefrontsChanged": false]
func save() throws {
    try JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
        .write(to: URL(fileURLWithPath: args[3]), options: .atomic)
}
func b64(_ d: Data) -> String {
    d.base64EncodedString().replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
}
do {
    let config = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: configPath))) as! [String: String]
    let appID = config["app_id"]!, bundle = config["bundle_id"]!, buildNumber = config["build"]!
    let key = try P256.Signing.PrivateKey(pemRepresentation: String(contentsOfFile: args[1], encoding: .utf8))
    func token() throws -> String {
        let now = Int(Date().timeIntervalSince1970)
        let h = b64(try JSONSerialization.data(withJSONObject: ["alg":"ES256", "kid":keyID, "typ":"JWT"]))
        let c = b64(try JSONSerialization.data(withJSONObject: ["iss":issuer, "iat":now, "exp":now+600, "aud":"appstoreconnect-v1"]))
        let text = h + "." + c
        return text + "." + b64(try key.signature(for: Data(text.utf8)).rawRepresentation)
    }
    func api(_ path: String, _ query: [String: String] = [:], body: [String: Any]? = nil) throws -> [String: Any] {
        // The sole possible mutation is existing group's builds linkage below.
        if body != nil && !(args[2] == "internal" && path.hasPrefix("v1/betaGroups/") && path.hasSuffix("/relationships/builds")) {
            throw SafeASCError(code: "MUTATION_NOT_ALLOWED")
        }
        var url = URLComponents(string: "https://api.appstoreconnect.apple.com/" + path)!
        url.queryItems = query.sorted(by: {$0.key < $1.key}).map { URLQueryItem(name:$0.key,value:$0.value) }
        var req = URLRequest(url: url.url!); req.timeoutInterval = 35
        req.setValue("Bearer " + (try token()), forHTTPHeaderField: "Authorization")
        if let body { req.httpMethod = "POST"; req.httpBody = try JSONSerialization.data(withJSONObject: body)
            req.setValue("application/json", forHTTPHeaderField:"Content-Type") }
        let sem = DispatchSemaphore(value:0)
        var result: Data?; var status = 0; var failed = false
        URLSession.shared.dataTask(with:req) { d,r,e in result=d; status=(r as? HTTPURLResponse)?.statusCode ?? 0; failed=e != nil; sem.signal() }.resume()
        guard sem.wait(timeout:.now()+40) == .success, !failed else { throw SafeASCError(code:"NETWORK_TIMEOUT") }
        guard status == 200 || (body != nil && status == 204) else { throw SafeASCError(code:"HTTP_\(status)") }
        if status == 204 { return [:] }
        guard let d=result, let json=try JSONSerialization.jsonObject(with:d) as? [String:Any] else { throw SafeASCError(code:"RESPONSE_SHAPE") }
        return json
    }
    func rows(_ json:[String:Any]) -> [[String:Any]] { json["data"] as? [[String:Any]] ?? [] }
    func attrs(_ row:[String:Any]) -> [String:Any] { row["attributes"] as? [String:Any] ?? [:] }
    func safe(_ a:[String:Any], _ keys:[String]) -> [String:Any] { a.filter { keys.contains($0.key) } }
    func attempt(_ key:String, _ operation:() throws -> Any) {
        do { report[key] = try operation() }
        catch let e as SafeASCError { report[key] = ["status":"NOT_READ_BACK", "safe_error":e.code] }
        catch { report[key] = ["status":"NOT_READ_BACK", "safe_error":"PRIVATE_DETAIL_SUPPRESSED"] }
    }
    let appResponse = try api("v1/apps/"+appID)
    guard let app=appResponse["data"] as? [String:Any], attrs(app)["bundleId"] as? String == bundle else { throw SafeASCError(code:"APP_IDENTITY_MISMATCH") }
    report["app"] = safe(attrs(app), ["name","bundleId","primaryLocale","contentRightsDeclaration"])
    report["appID"] = appID
    let builds = rows(try api("v1/builds", ["filter[app]":appID,"filter[version]":buildNumber,"limit":"2", "include":"preReleaseVersion"]))
    report["candidateBuildNumber"] = buildNumber
    report["candidateNumberAvailable"] = builds.isEmpty
    report["candidateBuilds"] = builds.map { ["id":$0["id"] ?? NSNull(), "attributes":safe(attrs($0),["version","processingState","buildAudienceType","minOsVersion","usesNonExemptEncryption","expired"])] }
    attempt("versions") {
        try rows(api("v1/apps/"+appID+"/appStoreVersions", ["filter[versionString]":"0.1.0", "filter[platform]":"IOS", "limit":"10"])).map { v -> [String:Any] in
            let id=v["id"] as! String
            var data:[String:Any] = ["id":id,"attributes":safe(attrs(v),["versionString","appStoreState","appVersionState","releaseType","copyright","usesIdfa"])]
            data["selectedBuild"] = try api("v1/appStoreVersions/"+id+"/build")["data"] ?? NSNull()
            // Selected-build responses contain only public binary metadata; reduce explicitly.
            if let b = data["selectedBuild"] as? [String:Any] {
                data["selectedBuild"] = ["id":b["id"] ?? NSNull(), "attributes":safe(attrs(b),["version","processingState","buildAudienceType"])]
            }
            let locs=rows(try api("v1/appStoreVersions/"+id+"/appStoreVersionLocalizations",["limit":"50"]))
            data["localizations"] = try locs.map { l -> [String:Any] in
                let la=attrs(l)
                var result=safe(la,["locale","description","keywords","promotionalText","supportUrl","marketingUrl"])
                let sets=rows(try api("v1/appStoreVersionLocalizations/"+(l["id"] as! String)+"/appScreenshotSets",["limit":"50"]))
                result["screenshotSets"] = try sets.map { s -> [String:Any] in
                    let shots=rows(try api("v1/appScreenshotSets/"+(s["id"] as! String)+"/appScreenshots",["limit":"50"]))
                    return ["displayType":attrs(s)["screenshotDisplayType"] ?? NSNull(), "count":shots.count,
                        "screenshots":shots.map { shot -> [String:Any] in
                            let a=attrs(shot); let image=a["imageAsset"] as? [String:Any] ?? [:]
                            return ["fileName":a["fileName"] ?? NSNull(), "fileSize":a["fileSize"] ?? NSNull(),
                                "sourceFileChecksum":a["sourceFileChecksum"] ?? NSNull(),
                                "width":image["width"] ?? NSNull(), "height":image["height"] ?? NSNull(),
                                "state":(a["assetDeliveryState"] as? [String:Any])?["state"] ?? NSNull()]
                        }]
                }
                return result
            }
            do {
                let review=try api("v1/appStoreVersions/"+id+"/appStoreReviewDetail")["data"] as? [String:Any] ?? [:]
                let a=attrs(review)
                let required=["contactFirstName","contactLastName","contactPhone","contactEmail"]
                data["reviewContact"] = ["complete":required.allSatisfy { !(a[$0] as? String ?? "").isEmpty },
                    "demoAccountRequired":a["demoAccountRequired"] ?? NSNull(),
                    "notesPresent": !(a["notes"] as? String ?? "").isEmpty,
                    "privateValuesPublished":false]
            } catch { data["reviewContact"] = ["status":"NOT_READ_BACK"] }
            return data
        }
    }
    attempt("appInfos") {
        try rows(api("v1/apps/"+appID+"/appInfos",["limit":"10"])).map { info -> [String:Any] in
            let id=info["id"] as! String
            var data:[String:Any]=["id":id, "attributes":safe(attrs(info),["appStoreState","appStoreAgeRating","brazilAgeRating","kidsAgeBand"])]
            let declaration=try api("v1/appInfos/"+id+"/ageRatingDeclaration")["data"] as? [String:Any] ?? [:]
            // All declaration attributes are public questionnaire booleans/enums/optional public URL.
            let keys=["advertising","alcoholTobaccoOrDrugUseOrReferences","contests","gambling","gamblingSimulated","gunsOrOtherWeapons","healthOrWellnessTopics","kidsAgeBand","lootBox","medicalOrTreatmentInformation","messagingAndChat","parentalControls","ageAssurance","profanityOrCrudeHumor","sexualContentGraphicAndNudity","sexualContentOrNudity","socialMedia","socialMediaAgeRestricted","horrorOrFearThemes","matureOrSuggestiveThemes","unrestrictedWebAccess","userGeneratedContent","violenceCartoonOrFantasy","violenceRealisticProlongedGraphicOrSadistic","violenceRealistic","ageRatingOverride","ageRatingOverrideV2","koreaAgeRatingOverride","developerAgeRatingInfoUrl"]
            data["ageRatingDeclaration"] = safe(attrs(declaration),keys)
            data["localizations"] = rows(try api("v1/appInfos/"+id+"/appInfoLocalizations",["limit":"50"])).map { safe(attrs($0),["locale","name","subtitle","privacyPolicyUrl"]) }
            return data
        }
    }
    attempt("availability") {
        let availability=try api("v1/apps/"+appID+"/appAvailabilityV2")["data"] as? [String:Any] ?? [:]
        guard let id=availability["id"] as? String else { throw SafeASCError(code:"AVAILABILITY_SHAPE") }
        let territories=rows(try api("v2/appAvailabilities/"+id+"/territoryAvailabilities",["limit":"200", "include":"territory"]))
        return ["availableInNewTerritories":attrs(availability)["availableInNewTerritories"] ?? NSNull(),
            "territories":territories.map { t -> [String:Any] in
                let rel=t["relationships"] as? [String:Any] ?? [:]
                let tr=rel["territory"] as? [String:Any] ?? [:]
                return ["territory":(tr["data"] as? [String:Any])?["id"] ?? NSNull(),
                    "attributes":safe(attrs(t),["available","contentStatuses","releaseDate","preOrderEnabled"])]
            }]
    }
    attempt("pricing") {
        let schedule=try api("v1/apps/"+appID+"/appPriceSchedule")["data"] as? [String:Any] ?? [:]
        guard let id=schedule["id"] as? String else { throw SafeASCError(code:"PRICE_SCHEDULE_SHAPE") }
        let response=try api("v1/appPriceSchedules/"+id+"/manualPrices",["limit":"200", "include":"appPricePoint,territory"])
        return ["pricePoints":(response["included"] as? [[String:Any]] ?? []).filter { $0["type"] as? String == "appPricePoints" }.map { safe(attrs($0),["customerPrice","proceeds"]) }]
    }
    attempt("reviewSubmissions") {
        rows(try api("v1/apps/"+appID+"/reviewSubmissions",["limit":"10"])).map { safe(attrs($0),["state","platform","submittedDate"]) }
    }
    let groups=rows(try api("v1/apps/"+appID+"/betaGroups",["limit":"200"]))
    let internalGroups=groups.filter { attrs($0)["isInternalGroup"] as? Bool == true }
    report["existingInternalGroupCount"] = internalGroups.count
    report["appPrivacyLabel"] = ["status":"NOT_READ_BACK", "reason":"Not exposed by this allowlisted ASC API flow; owner portal evidence required"]
    if args[2] == "internal" {
        guard builds.count == 1, let build=builds.first, let id=build["id"] as? String,
              attrs(build)["processingState"] as? String == "VALID", attrs(build)["buildAudienceType"] as? String == "APP_STORE_ELIGIBLE",
              !internalGroups.isEmpty else { throw SafeASCError(code:"INTERNAL_BUILD_OR_EXISTING_GROUP_NOT_READY") }
        var results:[[String:Any]]=[]
        for group in internalGroups {
            let gid=group["id"] as! String
            var associated=rows(try api("v1/betaGroups/"+gid+"/builds",["limit":"200"])).contains { $0["id"] as? String == id }
            let before=associated
            if !associated {
                _ = try api("v1/betaGroups/"+gid+"/relationships/builds",body:["data":[["type":"builds","id":id]]])
                associated=rows(try api("v1/betaGroups/"+gid+"/builds",["limit":"200"])).contains { $0["id"] as? String == id }
            }
            guard associated else { throw SafeASCError(code:"INTERNAL_ASSOCIATION_UNCONFIRMED") }
            results.append(["existingInternalGroup":true, "alreadyAssociated":before, "associationReadback":associated])
        }
        report["internalGroupAssociation"] = results
        let detail=try api("v1/builds/"+id+"/buildBetaDetail")["data"] as? [String:Any] ?? [:]
        report["buildBetaDetail"] = safe(attrs(detail),["internalBuildState","externalBuildState","autoNotifyEnabled"])
        report["ownerInstalled"] = "NOT_RUN"
    }
    try save(); print("S05_R2_ASC_SAFE_READBACK_COMPLETE " + args[2])
} catch let e as SafeASCError {
    report["failure"] = e.code; try? save(); print("S05_R2_ASC_FAILED " + e.code); exit(1)
} catch {
    report["failure"] = "PRIVATE_DETAIL_SUPPRESSED"; try? save(); print("S05_R2_ASC_FAILED PRIVATE_DETAIL_SUPPRESSED"); exit(1)
}
