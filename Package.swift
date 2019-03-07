// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sketching",
    products: [
        .library(name: "Sketching", targets: ["Sketching"]),
    ],
    targets: [
        .target(name: "Bridged", dependencies: []),
        .target(name: "Sketching", dependencies: [.target(name: "Bridged")]),
        .testTarget(name: "SketchingTests", dependencies: ["Sketching"]),
    ]
)
