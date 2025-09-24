// swift-tools-version:6.0

import PackageDescription


let package = Package(
    name: "Phoenix",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
    products: [
        .library(name: "Phoenix", targets: ["Phoenix"]),
        .library(name: "PhoenixPH", targets: ["PhoenixPH"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hidden-spectrum/posthog-ios.git", branch: "disable-swizzling"),
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
