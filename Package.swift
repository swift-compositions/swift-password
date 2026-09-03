// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-password",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .macCatalyst(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "PasswordValidation", targets: ["PasswordValidation"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-compositions/swift-translating.git", branch: "main"),
        .package(
            url: "https://github.com/swift-compositions/swift-translating-dependencies.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-compositions/swift-dependencies.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "PasswordValidation",
            dependencies: [
                .product(name: "Translating", package: "swift-translating"),
                .product(name: "Translating Dependencies", package: "swift-translating-dependencies"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "PasswordValidation Tests",
            dependencies: [
                .target(name: "PasswordValidation"),
                .product(name: "Dependencies Test Support", package: "swift-dependencies"),
            ]
        ),
    ]
)

