@preconcurrency import Photos
import SwiftUI
import UIKit

struct ConfirmationView: View {
    @ObservedObject var model: PhotoLibraryModel
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)

    var body: some View {
        Group {
            if model.authorization != .authorized {
                Text("permission.blocked")
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("confirm.instructions")
                        Text("selection.selected") + Text(" \(model.selection.count)/200")
                        LazyVGrid(columns: columns, spacing: 4) {
                            ForEach(model.selection.orderedPhotos, id: \.localIdentifier) { entry in
                                if let asset = model.asset(for: entry.localIdentifier) {
                                    Button {
                                        model.removeOnConfirm(entry.localIdentifier)
                                    } label: {
                                        ConfirmationThumbnail(asset: asset)
                                            .aspectRatio(1, contentMode: .fill)
                                            .clipped()
                                            .overlay(alignment: .topTrailing) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.title2)
                                                    .foregroundStyle(.white, .black.opacity(0.7))
                                                    .padding(4)
                                            }
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("confirm.remove")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("confirm.title")
    }
}

private struct ConfirmationThumbnail: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        GeometryReader { geometry in
            Group {
                if let image {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    Rectangle().fill(.quaternary)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .task(id: asset.localIdentifier) {
                let options = PHImageRequestOptions()
                options.deliveryMode = .opportunistic
                options.resizeMode = .fast
                options.isNetworkAccessAllowed = false
                let scale = UIScreen.main.scale
                let size = CGSize(width: geometry.size.width * scale, height: geometry.size.height * scale)
                PHImageManager.default().requestImage(for: asset, targetSize: size,
                    contentMode: .aspectFill, options: options) { result, _ in
                    DispatchQueue.main.async { image = result }
                }
            }
        }
    }
}
