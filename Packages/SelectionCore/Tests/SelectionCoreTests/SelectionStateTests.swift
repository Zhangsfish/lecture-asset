import Foundation
import XCTest
@testable import SelectionCore

final class SelectionStateTests: XCTestCase {
    func testChronologicalOrderingKeepsSelectionOrderForTiesAndNil() {
        var state = SelectionState()
        let early = Date(timeIntervalSince1970: 100)
        let late = Date(timeIntervalSince1970: 200)
        state.setSelected(true, identifier: "nil-first", creationDate: nil)
        state.setSelected(true, identifier: "late", creationDate: late)
        state.setSelected(true, identifier: "early-a", creationDate: early)
        state.setSelected(true, identifier: "early-b", creationDate: early)
        state.setSelected(true, identifier: "nil-second", creationDate: nil)
        XCTAssertEqual(state.orderedPhotos.map(\.localIdentifier), [
            "early-a", "early-b", "late", "nil-first", "nil-second"
        ])
        XCTAssertEqual(state.orderedPhotos.map(\.selectionIndex), [3, 4, 2, 1, 5])
    }

    func testSelectionLimitAndDeselectReleasesSlot() {
        var state = SelectionState()
        for index in 0..<SelectionState.maximumCount {
            XCTAssertEqual(state.setSelected(true, identifier: "\(index)", creationDate: nil), .selected)
        }
        XCTAssertEqual(state.setSelected(true, identifier: "extra", creationDate: nil), .limitReached)
        XCTAssertEqual(state.count, 200)
        XCTAssertEqual(state.setSelected(false, identifier: "0", creationDate: nil), .deselected)
        XCTAssertEqual(state.setSelected(true, identifier: "extra", creationDate: nil), .selected)
        XCTAssertEqual(state.count, 200)
        XCTAssertEqual(state.orderedPhotos.last?.selectionIndex, 201)
    }

    func testToggleAndConfirmRemovalAffectFinalSourceSet() {
        var state = SelectionState()
        XCTAssertEqual(state.toggle(identifier: "a", creationDate: nil), .selected)
        XCTAssertEqual(state.orderedPhotos.first?.selectionIndex, 1)
        XCTAssertEqual(state.toggle(identifier: "a", creationDate: nil), .deselected)
        XCTAssertEqual(state.toggle(identifier: "a", creationDate: nil), .selected)
        XCTAssertEqual(state.orderedPhotos.first?.selectionIndex, 2)
        XCTAssertEqual(state.setSelected(false, identifier: "a", creationDate: nil), .deselected)
        XCTAssertFalse(state.identifiers.contains("a"))
        XCTAssertTrue(state.orderedPhotos.isEmpty)
    }

    func testSweepActionIsFixedAndRevisitedCellIsIdempotent() {
        var state = SelectionState()
        var selectingSweep = SweepSelection(startIdentifier: "a", isSelected: false)
        XCTAssertEqual(selectingSweep.visit(identifier: "a", creationDate: nil, in: &state), .selected)
        XCTAssertEqual(selectingSweep.visit(identifier: "b", creationDate: nil, in: &state), .selected)
        XCTAssertEqual(selectingSweep.visit(identifier: "a", creationDate: nil, in: &state), .unchanged)
        XCTAssertEqual(state.count, 2)

        var removingSweep = SweepSelection(startIdentifier: "a", isSelected: true)
        XCTAssertEqual(removingSweep.visit(identifier: "a", creationDate: nil, in: &state), .deselected)
        XCTAssertEqual(removingSweep.visit(identifier: "b", creationDate: nil, in: &state), .deselected)
        XCTAssertEqual(removingSweep.visit(identifier: "a", creationDate: nil, in: &state), .unchanged)
        XCTAssertEqual(state.count, 0)
    }
}
