import XCTest
@testable import Lecture_Asset

@MainActor
final class AgeAssuranceTests: XCTestCase {
    private enum Failure: Error { case injected }

    func testNotRequiredNeverPromptsAndDoesNotRepeatAfterEntry() async {
        let service = AgeAssuranceService()
        var prompts = 0
        var queries = 0
        for _ in 0..<2 {
            await service.check(supported: true, eligibility: { queries += 1; return false },
                                request: { prompts += 1; return .declined })
        }
        XCTAssertEqual(service.state, .notRequired)
        XCTAssertTrue(service.state.allowsWork)
        XCTAssertEqual(prompts, 0)
        XCTAssertEqual(queries, 1)
    }

    func testVerifiedMinorPreservesAppleJurisdictionRangesAndAllowsWork() async {
        for bounds in [(nil, 12), (13, 15), (16, 17)] as [(Int?, Int?)] {
            let service = AgeAssuranceService()
            let receipt = AgeAssuranceReceipt(lowerBound: bounds.0, upperBound: bounds.1,
                                               declaration: "guardianDeclared")
            await service.check(supported: true, eligibility: { true }, request: { .shared(receipt) })
            XCTAssertEqual(service.state, .verified(receipt))
            XCTAssertTrue(service.state.allowsWork)
        }
    }

    func testVerifiedAdultAllowsWork() async {
        let service = AgeAssuranceService()
        let receipt = AgeAssuranceReceipt(lowerBound: 18, upperBound: nil, declaration: "confirmed")
        await service.check(supported: true, eligibility: { true }, request: { .shared(receipt) })
        XCTAssertEqual(service.state, .verified(receipt))
        XCTAssertTrue(service.state.allowsWork)
    }

    func testSharedRangeDoesNotRepeatEligibilityOrPromptAfterEntry() async {
        for receipt in [
            AgeAssuranceReceipt(lowerBound: 16, upperBound: 17, declaration: "guardianDeclared"),
            AgeAssuranceReceipt(lowerBound: 18, upperBound: nil, declaration: "confirmed")
        ] {
            let service = AgeAssuranceService()
            var queries = 0
            var prompts = 0
            for _ in 0..<2 {
                await service.check(supported: true,
                                    eligibility: { queries += 1; return true },
                                    request: { prompts += 1; return .shared(receipt) })
            }
            XCTAssertEqual(service.state, .verified(receipt))
            XCTAssertTrue(service.state.allowsWork)
            XCTAssertEqual(queries, 1)
            XCTAssertEqual(prompts, 1)
        }
    }

    func testDeclinedRemainsUnresolvedAndCanRetry() async {
        let service = AgeAssuranceService()
        await service.check(supported: true, eligibility: { true }, request: { .declined })
        XCTAssertEqual(service.state, .unresolved(.declined))
        XCTAssertFalse(service.state.allowsWork)
        await service.check(supported: true, eligibility: { false }, request: { .declined })
        XCTAssertEqual(service.state, .notRequired)
    }

    func testAPIErrorIsUnresolvedAndEligibilityErrorNeverPrompts() async {
        let service = AgeAssuranceService()
        var prompts = 0
        await service.check(supported: true, eligibility: { throw Failure.injected },
                            request: { prompts += 1; return .declined })
        XCTAssertEqual(service.state, .unresolved(.eligibilityError))
        XCTAssertEqual(prompts, 0)
        await service.check(supported: true, eligibility: { true }, request: { throw Failure.injected })
        XCTAssertEqual(service.state, .unresolved(.requestError))
        XCTAssertFalse(service.state.allowsWork)
    }

    func testUnsupportedOSNeverCallsAppleOrPretendsVerified() async {
        let service = AgeAssuranceService()
        await service.check(supported: false,
                            eligibility: { XCTFail("unsupported must not call API"); return false },
                            request: { XCTFail("unsupported must not prompt"); return .declined })
        XCTAssertEqual(service.state, .unresolved(.unsupportedOS))
        XCTAssertFalse(service.state.allowsWork)
    }

    func testMissingBoundsRemainUnresolvedAndFreshSessionHasNoReceipt() async {
        let service = AgeAssuranceService()
        await service.check(supported: true, eligibility: { true }, request: {
            .shared(AgeAssuranceReceipt(lowerBound: nil, upperBound: nil, declaration: nil))
        })
        XCTAssertEqual(service.state, .unresolved(.incompleteResponse))
        XCTAssertEqual(AgeAssuranceService().state, .checking)
    }
}
