// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "G80Player",
    platforms: [.iOS(.v13),.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "G80Player",
            targets: ["G80Player"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kingslay/KSPlayer.git", .branch("develop")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "G80Player",
            dependencies: ["KSPlayer","SnapKit"]),
        .testTarget(
            name: "G80PlayerTests",
            dependencies: ["G80Player"]),
    ]
)
