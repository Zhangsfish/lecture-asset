@preconcurrency import Photos
import SwiftUI
import UIKit
import SelectionCore

struct PhotoGridView: UIViewControllerRepresentable {
    @ObservedObject var model: PhotoLibraryModel

    func makeUIViewController(context: Context) -> GalleryViewController {
        GalleryViewController(model: model)
    }

    func updateUIViewController(_ controller: GalleryViewController, context: Context) {
        controller.update(assets: model.assets)
        controller.refreshVisibleSelection()
    }
}

@MainActor
final class GalleryViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSourcePrefetching, UIGestureRecognizerDelegate {

    private let model: PhotoLibraryModel
    private let imageManager = PHCachingImageManager()
    private var assets: [PHAsset] = []
    private var collectionView: UICollectionView!
    private var sweep: SweepSelection?
    private var visitedIndexPaths: Set<IndexPath> = []
    private var lastTouchPoint: CGPoint = .zero
    private var displayLink: CADisplayLink?
    private var capNotifiedInSweep = false
    private let spacing: CGFloat = 2

    init(model: PhotoLibraryModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is unavailable") }

    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        let grid = UICollectionView(frame: .zero, collectionViewLayout: layout)
        grid.backgroundColor = .systemBackground
        grid.dataSource = self
        grid.delegate = self
        grid.prefetchDataSource = self
        grid.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        grid.alwaysBounceVertical = true
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handleSweep(_:)))
        press.minimumPressDuration = 0.15
        press.allowableMovement = 12
        press.delegate = self
        grid.addGestureRecognizer(press)
        collectionView = grid
        view = grid
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        finishSweep()
    }

    func update(assets newAssets: [PHAsset]) {
        let identifiers = newAssets.map(\.localIdentifier)
        guard identifiers != assets.map(\.localIdentifier) else { return }
        finishSweep()
        assets = newAssets
        guard isViewLoaded else { return }
        imageManager.stopCachingImagesForAllAssets()
        collectionView.reloadData()
    }

    func refreshVisibleSelection() {
        guard isViewLoaded else { return }
        for case let cell as PhotoCell in collectionView.visibleCells {
            guard let path = collectionView.indexPath(for: cell), path.item < assets.count else { continue }
            cell.setSelectedAppearance(model.isSelected(assets[path.item]))
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath
        ) as! PhotoCell
        let asset = assets[indexPath.item]
        cell.configure(
            asset: asset,
            selected: model.isSelected(asset),
            manager: imageManager,
            targetSize: thumbnailSize
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < assets.count else { return }
        let asset = assets[indexPath.item]
        let result = model.toggle(asset)
        if result == .limitReached { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
        refreshVisibleSelection()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = floor((collectionView.bounds.width - spacing * 3) / 4)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let items = indexPaths.compactMap { $0.item < assets.count ? assets[$0.item] : nil }
        imageManager.startCachingImages(for: items, targetSize: thumbnailSize,
                                        contentMode: .aspectFill, options: thumbnailOptions)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let items = indexPaths.compactMap { $0.item < assets.count ? assets[$0.item] : nil }
        imageManager.stopCachingImages(for: items, targetSize: thumbnailSize,
                                       contentMode: .aspectFill, options: thumbnailOptions)
    }

    private var thumbnailSize: CGSize {
        let width = max(80, (collectionView?.bounds.width ?? 400) / 4)
        let scale = view.window?.windowScene?.screen.scale ?? UIScreen.main.scale
        return CGSize(width: width * scale, height: width * scale)
    }

    private var thumbnailOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = false
        return options
    }

    @objc private func handleSweep(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            guard let path = collectionView.indexPathForItem(at: point), path.item < assets.count else {
                return
            }
            lastTouchPoint = point
            let asset = assets[path.item]
            sweep = SweepSelection(startIdentifier: asset.localIdentifier, isSelected: model.isSelected(asset))
            visitedIndexPaths = []
            capNotifiedInSweep = false
            visitCell(at: point)
            startAutoscroll()
        case .changed:
            visitSegment(from: lastTouchPoint, to: point)
            lastTouchPoint = point
        case .ended, .cancelled, .failed:
            finishSweep()
        default:
            break
        }
    }

    private func visitSegment(from start: CGPoint, to end: CGPoint) {
        let length = hypot(end.x - start.x, end.y - start.y)
        let steps = max(1, Int(ceil(length / 12)))
        for step in 1...steps {
            let fraction = CGFloat(step) / CGFloat(steps)
            visitCell(at: CGPoint(x: start.x + (end.x - start.x) * fraction,
                                  y: start.y + (end.y - start.y) * fraction))
        }
    }

    private func visitCell(at point: CGPoint) {
        guard var activeSweep = sweep,
              let path = collectionView.indexPathForItem(at: point),
              path.item < assets.count,
              visitedIndexPaths.insert(path).inserted else { return }
        let result = model.visit(assets[path.item], sweep: &activeSweep)
        sweep = activeSweep
        if result == .limitReached && !capNotifiedInSweep {
            capNotifiedInSweep = true
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
        refreshVisibleSelection()
    }

    private func startAutoscroll() {
        displayLink?.invalidate()
        let link = CADisplayLink(target: self, selector: #selector(autoscrollTick))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    @objc private func autoscrollTick() {
        guard sweep != nil else { return }
        let edge: CGFloat = 72
        let height = collectionView.bounds.height
        let viewportY = lastTouchPoint.y - collectionView.contentOffset.y
        let distance: CGFloat
        if viewportY < edge {
            distance = -min(1, (edge - viewportY) / edge)
        } else if viewportY > height - edge {
            distance = min(1, (viewportY - (height - edge)) / edge)
        } else {
            return
        }
        let minY = -collectionView.adjustedContentInset.top
        let maxY = max(minY, collectionView.contentSize.height - height + collectionView.adjustedContentInset.bottom)
        let nextY = min(max(collectionView.contentOffset.y + distance * 14, minY), maxY)
        guard nextY != collectionView.contentOffset.y else { return }
        let oldPoint = lastTouchPoint
        collectionView.contentOffset.y = nextY
        lastTouchPoint.y = viewportY + nextY
        visitSegment(from: oldPoint, to: lastTouchPoint)
    }

    private func finishSweep() {
        displayLink?.invalidate()
        displayLink = nil
        sweep = nil
        visitedIndexPaths = []
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
}

@MainActor
private final class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    private let imageView = UIImageView()
    private let selectionBadge = UIImageView()
    private let liveBadge = UILabel()
    private var requestID: PHImageRequestID = PHInvalidImageRequestID
    private weak var requestManager: PHImageManager?
    private var representedIdentifier: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(imageView)

        selectionBadge.tintColor = .systemBlue
        selectionBadge.backgroundColor = .white
        selectionBadge.layer.cornerRadius = 12
        selectionBadge.frame = CGRect(x: 4, y: 4, width: 24, height: 24)
        contentView.addSubview(selectionBadge)

        liveBadge.text = "LIVE"
        liveBadge.font = .systemFont(ofSize: 9, weight: .bold)
        liveBadge.textColor = .white
        liveBadge.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        liveBadge.frame = CGRect(x: 4, y: 32, width: 30, height: 15)
        contentView.addSubview(liveBadge)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is unavailable") }

    override func prepareForReuse() {
        super.prepareForReuse()
        if requestID != PHInvalidImageRequestID { requestManager?.cancelImageRequest(requestID) }
        requestID = PHInvalidImageRequestID
        representedIdentifier = nil
        imageView.image = nil
    }

    func configure(asset: PHAsset, selected: Bool, manager: PHImageManager, targetSize: CGSize) {
        representedIdentifier = asset.localIdentifier
        requestManager = manager
        setSelectedAppearance(selected)
        liveBadge.isHidden = !asset.mediaSubtypes.contains(.photoLive)
        let identifier = asset.localIdentifier
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = false
        requestID = manager.requestImage(for: asset, targetSize: targetSize,
                                         contentMode: .aspectFill, options: options) { [weak self] image, _ in
            DispatchQueue.main.async { [weak self] in
                guard self?.representedIdentifier == identifier else { return }
                self?.imageView.image = image
            }
        }
    }

    func setSelectedAppearance(_ selected: Bool) {
        selectionBadge.image = UIImage(systemName: selected ? "checkmark.circle.fill" : "circle")
        selectionBadge.accessibilityLabel = selected ? String(localized: "selection.selected") : String(localized: "selection.unselected")
    }
}
