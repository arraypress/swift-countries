// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-countries",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "Countries", targets: ["Countries"]),
    ],
    targets: [
        .target(name: "Countries"),
        .testTarget(name: "CountriesTests", dependencies: ["Countries"]),
    ]
)
