# Feather Mail Driver Memory

A mail driver for the Feather CMS mail component using AWS Memory.

## Getting started

⚠️ This repository is a work in progress, things can break until it reaches v1.0.0. 

Use at your own risk.

### Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-mail-driver-memory.git", .upToNextMinor(from: "0.2.0")),
```

and to your application target, add `FeatherMailDriverMemory` to your dependencies:

```swift
.product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory")
```

Example `Package.swift` file with `FeatherMailDriverMemory` as a dependency:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory.git", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(name: "MyApplication", dependencies: [
            .product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory")
        ]),
        .testTarget(name: "MyApplicationTests", dependencies: [
            .target(name: "MyApplication"),
        ]),
    ]
)
```

### Documentation

For more information, see the  official [API documentation](https://feather-framework.github.io/feather-mail-driver-memory/documentation/) for this package.
