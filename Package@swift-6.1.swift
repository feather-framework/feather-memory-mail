// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "feather-mail-driver-memory",

    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],

    products: [
        .library(name: "FeatherMailDriverMemory", targets: ["FeatherMailDriverMemory"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/feather-framework/feather-mail.git", .upToNextMinor(from: "0.5.0"))
        .package(path: "../feather-mail")
    ],
    targets: [
        .target(
            name: "FeatherMailDriverMemory",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
            ]
        ),
        .testTarget(
            name: "FeatherMailDriverMemoryTests",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "FeatherMailDriverMemory"),
            ]
        ),
    ]
)
