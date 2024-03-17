// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BCTags",
    platforms: [
        .macOS(.v13),
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "BCTags",
            targets: ["BCTags"]),
    ],
    dependencies: [
        .package(url: "https://github.com/BlockchainCommons/URKit.git", from: "14.0.0"),    
    ],
    targets: [
        .target(
            name: "BCTags",
            dependencies: [
                "URKit"
            ]
        ),
        .testTarget(
            name: "BCTagsTests",
            dependencies: ["BCTags"]),
    ]
)
