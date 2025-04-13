// swift-tools-version:6.0

import PackageDescription


let package = Package(
    name: "Phoenix",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15)],
    products: [
        .library(name: "Phoenix", targets: ["Phoenix"]),
        .library(name: "PhoenixPH", targets: ["PhoenixPH"]),
    ],
    dependencies: [
        .package(url: "https://github.com/PostHog/posthog-ios.git", from: "3.22.1"),
    ],
    targets: [
        .target(
            name: "Phoenix"
        ),
        .target(
            name: "PhoenixPH",
            dependencies: [
                .product(name: "PostHog", package: "posthog-ios"),
                "Phoenix",
            ]
        ),
        .testTarget(
            name: "PhoenixTests",
            dependencies: [
                "Phoenix",
            ]
        ),
    ]
)
