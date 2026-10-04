import Foundation
import XCTest
@testable import Lecture_Asset

final class LocalizationResourceTests: XCTestCase {
    func testReleaseBundleHasCompleteMatchingCatalogsAndLocalizedInfo() throws {
        var catalogs: [[String: String]] = []
        for (locale, name) in [("en", "Lecture Asset"), ("zh-Hans", "讲座照片整理")] {
            let path = try XCTUnwrap(Bundle.main.path(forResource: locale, ofType: "lproj"))
            let bundle = try XCTUnwrap(Bundle(path: path))
            let stringsURL = try XCTUnwrap(bundle.url(forResource: "Localizable", withExtension: "strings"))
            let values = try XCTUnwrap(NSDictionary(contentsOf: stringsURL) as? [String: String])
            XCTAssertGreaterThan(values.count, 100)
            XCTAssertTrue(values.allSatisfy { !$0.value.isEmpty && $0.value != $0.key })
            catalogs.append(values)
            let infoURL = try XCTUnwrap(bundle.url(forResource: "InfoPlist", withExtension: "strings"))
            let info = try XCTUnwrap(NSDictionary(contentsOf: infoURL) as? [String: String])
            XCTAssertEqual(info["CFBundleDisplayName"], name)
            XCTAssertFalse(try XCTUnwrap(info["NSPhotoLibraryUsageDescription"]).isEmpty)
            XCTAssertEqual(bundle.localizedString(forKey: "app.title", value: nil, table: nil), name)
        }
        XCTAssertEqual(Set(catalogs[0].keys), Set(catalogs[1].keys))
        XCTAssertEqual(catalogs[1]["about.privacyLive"], "实况照片仅归档静态 JPEG，不保存动态和声音；删除原照片会删除整张实况照片。")
        XCTAssertEqual(catalogs[1]["selection.liveBadge"], "实况")
        XCTAssertEqual(catalogs[0]["export.discardDetail"],
                       "Clear this job’s local JPEG, ZIP, PDF, OCR and recovery files. Anything not saved externally cannot be recovered from the App. Photos originals are kept.")
    }
}
