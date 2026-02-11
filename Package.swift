// swift-tools-version:6.1
import PackageDescription

// NOTE: https://github.com/swift-server/swift-http-server/blob/main/Package.swift
var defaultSwiftSettings: [SwiftSetting] = [
    
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0441-formalize-language-mode-terminology.md
    .swiftLanguageMode(.v6),
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),
    // https://forums.swift.org/t/experimental-support-for-lifetime-dependencies-in-swift-6-2-and-beyond/78638
    .enableExperimentalFeature("Lifetimes"),
    // https://github.com/swiftlang/swift/pull/65218
    .enableExperimentalFeature("AvailabilityMacro=featherMemoryMail:macOS 15, iOS 18, watchOS 9, tvOS 11, visionOS 2"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif


let package = Package(
    name: "feather-memory-mail",
    products: [
        .library(name: "FeatherMemoryMail", targets: ["FeatherMemoryMail"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(url: "https://github.com/feather-framework/feather-mail", exact: "1.0.0-beta.2"),
    ],
    targets: [
        .target(
            name: "FeatherMemoryMail",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "FeatherMemoryMailTestSuiteuite",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "FeatherMemoryMail"),
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
