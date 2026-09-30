// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ArchiveCore",
    platforms: [.iOS(.v18), .macOS(.v14)],
    products: [.library(name: "ArchiveCore", targets: ["ArchiveCore"])],
    dependencies: [.package(url: "https://github.com/weichsel/ZIPFoundation.git", exact: "0.9.20")],
    targets: [
        .target(name: "ArchiveCore", dependencies: [.product(name: "ZIPFoundation", package: "ZIPFoundation")]),
        .testTarget(name: "ArchiveCoreTests", dependencies: ["ArchiveCore"])
    ]
)
