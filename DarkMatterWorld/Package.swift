// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DarkMatterWorld",
    platforms: [
        .macOS(.v15),
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DarkMatterCore",
            targets: ["DarkMatterCore"]
        ),
        .library(
            name: "DarkMatterWorld",
            targets: ["DarkMatterWorld"]
        ),
        .library(
            name: "DarkMatterEngine",
            targets: ["DarkMatterEngine"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DarkMatterCore"
        ),
        .target(
            name: "DarkMatterWorld",
            dependencies: ["DarkMatterCore"]
        ),
        .target(
            name: "DarkMatterEngine",
            dependencies: ["DarkMatterWorld", "DarkMatterCore"]
        ),
        .testTarget(
            name: "DarkMatterWorldTests",
            dependencies: ["DarkMatterWorld"]
        ),
    ]
)
