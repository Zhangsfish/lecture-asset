// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SelectionCore",
    platforms: [.iOS(.v18)],
    products: [.library(name: "SelectionCore", targets: ["SelectionCore"])],
    targets: [
        .target(name: "SelectionCore"),
        .testTarget(name: "SelectionCoreTests", dependencies: ["SelectionCore"])
    ]
)
