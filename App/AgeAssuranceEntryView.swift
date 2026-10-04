// Current SDK's SwiftUI action lacks Sendable annotation. Calls remain serialized
// by the main-actor service; this import scopes compatibility to Apple's module.
@preconcurrency import DeclaredAgeRange
import SwiftUI

struct AgeAssuranceEntryView: View {
    var body: some View {
        if #available(iOS 26.2, *) {
            SupportedAgeAssuranceEntry()
        } else {
            // No regional eligibility API: no invented account/region fallback.
            // This deliberately remains a release blocker pending owner decision.
            AgeAssuranceUnresolvedView(issue: .unsupportedOS, retry: nil)
        }
    }
}

@available(iOS 26.2, *)
private struct SupportedAgeAssuranceEntry: View {
    @Environment(\.requestAgeRange) private var requestAgeRange
    @StateObject private var service = AgeAssuranceService()

    var body: some View {
        Group {
            switch service.state {
            case .notRequired, .verified:
                // Construct processing/PhotoKit models only after entry resolves.
                ContentView()
            case .checking: ProgressView()
            case .unresolved(let issue):
                AgeAssuranceUnresolvedView(issue: issue) { Task { await check() } }
            }
        }
        .task { await check() }
    }

    private func check() async {
        await service.check(supported: true, eligibility: {
            try await AppleAgeEligibility.required()
        }, request: {
            switch try await requestAgeRange(ageGates: 18) {
            case .sharing(let range):
                return .shared(AgeAssuranceReceipt(
                    lowerBound: range.lowerBound, upperBound: range.upperBound,
                    declaration: range.ageRangeDeclaration.map { String(describing: $0) }))
            case .declinedSharing: return .declined
            @unknown default: throw AgeAssuranceAdapterError.unknownResponse
            }
        })
    }
}

private enum AgeAssuranceAdapterError: Error { case unknownResponse }

// Keep the non-Sendable framework receiver inside a nonisolated async context;
// only its Sendable Bool crosses back to the main-actor state machine.
@available(iOS 26.2, *)
private enum AppleAgeEligibility {
    static func required() async throws -> Bool {
        try await AgeRangeService.shared.isEligibleForAgeFeatures
    }
}

private struct AgeAssuranceUnresolvedView: View {
    let issue: AgeAssuranceIssue
    let retry: (() -> Void)?
    @State private var showingAbout = false

    var body: some View {
        VStack(spacing: 18) {
            Text("age.unresolvedTitle").font(.title2.bold())
            Text(issue == .unsupportedOS ? "age.unsupported" : "age.unresolved")
                .multilineTextAlignment(.center)
            if let retry {
                Button("age.retry", action: retry).buttonStyle(.borderedProminent)
            }
            Button("about.title") { showingAbout = true }
        }
        .padding(32)
        .sheet(isPresented: $showingAbout) { AboutSupportView() }
    }
}
