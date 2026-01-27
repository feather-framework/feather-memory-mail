// swift-tools-version:6.1
import PackageDescription

var defaultSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .enableExperimentalFeature(
        "AvailabilityMacro=FeatherMailAvailability:macOS 13, iOS 16, watchOS 9, tvOS 16, visionOS 1"
    ),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableExperimentalFeature("Lifetimes"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif


let package = Package(
    name: "feather-mail-driver-memory",
    products: [
        .library(name: "FeatherMailDriverMemory", targets: ["FeatherMailDriverMemory"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(url: "https://github.com/feather-framework/feather-mail.git", .upToNextMinor(from: "1.0.0-beta.1")),
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
