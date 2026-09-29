import Foundation

public struct SelectedPhoto: Equatable, Sendable {
    public let localIdentifier: String
    public let creationDate: Date?
    public let selectionIndex: Int

    public init(localIdentifier: String, creationDate: Date?, selectionIndex: Int) {
        self.localIdentifier = localIdentifier
        self.creationDate = creationDate
        self.selectionIndex = selectionIndex
    }
}

public enum SelectionResult: Equatable, Sendable {
    case selected
    case deselected
    case unchanged
    case limitReached
}

public struct SelectionState: Sendable {
    public static let maximumCount = 200

    private var entries: [String: SelectedPhoto] = [:]
    private var nextIndex = 1

    public init() {}

    public var count: Int { entries.count }
    public var identifiers: Set<String> { Set(entries.keys) }

    public func contains(_ identifier: String) -> Bool {
        entries[identifier] != nil
    }

    @discardableResult
    public mutating func setSelected(
        _ selected: Bool,
        identifier: String,
        creationDate: Date?
    ) -> SelectionResult {
        if selected {
            if entries[identifier] != nil { return .unchanged }
            guard entries.count < Self.maximumCount else { return .limitReached }
            entries[identifier] = SelectedPhoto(
                localIdentifier: identifier,
                creationDate: creationDate,
                selectionIndex: nextIndex
            )
            nextIndex += 1
            return .selected
        }
        return entries.removeValue(forKey: identifier) == nil ? .unchanged : .deselected
    }

    @discardableResult
    public mutating func toggle(identifier: String, creationDate: Date?) -> SelectionResult {
        setSelected(!contains(identifier), identifier: identifier, creationDate: creationDate)
    }

    public var orderedPhotos: [SelectedPhoto] {
        entries.values.sorted { lhs, rhs in
            switch (lhs.creationDate, rhs.creationDate) {
            case let (left?, right?) where left != right:
                return left < right
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            default:
                return lhs.selectionIndex < rhs.selectionIndex
            }
        }
    }
}

/// One sweep fixes its action at the first cell and visits each identifier once.
public struct SweepSelection: Sendable {
    public let selects: Bool
    private var visited: Set<String> = []

    public init(startIdentifier: String, isSelected: Bool) {
        selects = !isSelected
    }

    public mutating func visit(
        identifier: String,
        creationDate: Date?,
        in state: inout SelectionState
    ) -> SelectionResult {
        guard visited.insert(identifier).inserted else { return .unchanged }
        return state.setSelected(selects, identifier: identifier, creationDate: creationDate)
    }
}
