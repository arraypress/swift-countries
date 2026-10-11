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

// Swift 7's import rule, today: a file must import every module whose members
// it uses, rather than leaning on another file's imports.
for target in package.targets where target.type != .system && target.type != .binary && target.type != .plugin {
    target.swiftSettings = (target.swiftSettings ?? []) + [.enableUpcomingFeature("MemberImportVisibility")]
}
