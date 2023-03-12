// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarvelApp",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Hero", targets: ["Hero"]),
        .library(name: "HeroClient", targets: ["HeroClient"]),
        .library(name: "Utils", targets: ["Utils"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.51.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "APIClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .target(
            name: "HeroClient",
            dependencies: [
                "APIClient",
                "Models",
                "Utils",
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .target(name: "Models"),
        .target(name: "Utils"),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]
        ),
        .target(
            name: "Hero",
            dependencies: [
                "HeroClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .testTarget(
            name: "HeroTests",
            dependencies: ["Hero"]),
    ]
)
