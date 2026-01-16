# Feather Mail Driver Memory

MailMemory provides an in-memory mail driver and mailbox implementation for testing, previews, and local development.

It mirrors the behavior of real mail transports (SMTP, SES) without performing any network operations.

## Getting started

MailMemory is primarily intended for use in tests.
You can find working examples in the `Tests` directory.

```swift
let driver = MemoryMailDriver()

let mail = Mail(
    from: .init("from@example.com"),
    to: [.init("to@example.com")],
    subject: "Hello",
    body: .plainText("Body")
)

try await driver.send(mail)

let mailbox = await driver.getMailbox()
```

Requires Swift `6.1` or later.

## Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-mail-driver-memory.git", .upToNextMinor(from: "1.0.0-beta.1")),
```

and to your application target, add `FeatherMailDriverMemory` to your dependencies:

```swift
.product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory")
```

Example `Package.swift` file with `FeatherMailDriverMemory` as a dependency:

```swift
// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-mail-driver-memory.git", .upToNextMinor(from: "1.0.0-beta.1")),
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

## Documentation

For more information, see the  official [API documentation](https://feather-framework.github.io/feather-mail-driver-memory/documentation/) for this package.
