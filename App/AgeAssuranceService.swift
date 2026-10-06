import Combine

// Session-only receipt, not a birthday, identity, account or persisted age record.
struct AgeAssuranceReceipt: Equatable {
    let lowerBound: Int?
    let upperBound: Int?
    let declaration: String?
}

enum AgeAssuranceIssue: Equatable {
    case unsupportedOS, declined, eligibilityError, requestError, incompleteResponse
}

enum AgeAssuranceState: Equatable {
    case checking
    case notRequired
    // "verified" means Apple supplied a range, not that we verified an identity.
    case verified(AgeAssuranceReceipt)
    case unresolved(AgeAssuranceIssue)

    var allowsWork: Bool {
        switch self {
        case .notRequired, .verified: true
        case .checking, .unresolved: false
        }
    }
}

enum AgeAssuranceResponse {
    case shared(AgeAssuranceReceipt), declined
}

@MainActor
final class AgeAssuranceService: ObservableObject {
    @Published private(set) var state: AgeAssuranceState = .checking
    private var running = false

    func check(supported: Bool,
               eligibility: () async throws -> Bool,
               request: () async throws -> AgeAssuranceResponse) async {
        // No new request after successful entry, including scene activation.
        guard !running, !state.allowsWork else { return }
        running = true
        defer { running = false }
        state = .checking
        guard supported else {
            state = .unresolved(.unsupportedOS)
            return
        }
        let required: Bool
        do { required = try await eligibility() }
        catch { state = .unresolved(.eligibilityError); return }
        guard required else { state = .notRequired; return }
        do {
            switch try await request() {
            case .declined: state = .unresolved(.declined)
            case .shared(let receipt):
                guard receipt.lowerBound != nil || receipt.upperBound != nil else {
                    state = .unresolved(.incompleteResponse); return
                }
                // Preserve Apple's jurisdiction bounds; no 18+ restriction.
                state = .verified(receipt)
            }
        } catch { state = .unresolved(.requestError) }
    }
}
