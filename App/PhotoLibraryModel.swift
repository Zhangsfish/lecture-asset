import Photos
import SwiftUI
import SelectionCore

@MainActor
final class PhotoLibraryModel: ObservableObject {
    @Published private(set) var authorization: PHAuthorizationStatus = .notDetermined
    @Published private(set) var assets: [PHAsset] = []
    @Published private(set) var selection = SelectionState()
    @Published var showsSelectionLimit = false

    private var assetsByID: [String: PHAsset] = [:]

    init() {
        refreshAuthorization()
    }

    func refreshAuthorization() {
        let current = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        authorization = current
        if current == .authorized {
            reloadAssets()
        } else {
            assets = []
            assetsByID = [:]
            selection = SelectionState()
        }
    }

    func requestFullAccess() {
        Task {
            _ = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            refreshAuthorization()
        }
    }

    func reloadAssets() {
        guard authorization == .authorized else { return }
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        var fetched: [PHAsset] = []
        fetched.reserveCapacity(result.count)
        result.enumerateObjects { asset, _, _ in fetched.append(asset) }
        assets = fetched
        assetsByID = Dictionary(uniqueKeysWithValues: fetched.map { ($0.localIdentifier, $0) })
        for id in selection.identifiers where assetsByID[id] == nil {
            _ = selection.setSelected(false, identifier: id, creationDate: nil)
        }
    }

    func asset(for identifier: String) -> PHAsset? {
        assetsByID[identifier]
    }

    func isSelected(_ asset: PHAsset) -> Bool {
        selection.contains(asset.localIdentifier)
    }

    @discardableResult
    func toggle(_ asset: PHAsset) -> SelectionResult {
        apply(selection.toggle(identifier: asset.localIdentifier, creationDate: asset.creationDate))
    }

    @discardableResult
    func visit(_ asset: PHAsset, sweep: inout SweepSelection) -> SelectionResult {
        apply(sweep.visit(
            identifier: asset.localIdentifier,
            creationDate: asset.creationDate,
            in: &selection
        ))
    }

    func removeOnConfirm(_ identifier: String) {
        _ = selection.setSelected(false, identifier: identifier, creationDate: nil)
    }

    private func apply(_ result: SelectionResult) -> SelectionResult {
        if result == .limitReached { showsSelectionLimit = true }
        return result
    }
}
