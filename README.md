# Feather Mail Driver Memory

In-memory mail driver for Feather Mail, designed for tests and local development.
It mirrors the behavior of real mail transports (SMTP, SES) without performing any network operations.

![Release: 1.0.0-beta.1](https://img.shields.io/badge/Release-1%2E0%2E0--beta%2E1-F05138)

## Features

- In-memory mailbox with insertion-order storage
- Validates mail before storage
- Supports plain text, HTML, and attachments
- No network dependencies

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: macOS](https://img.shields.io/badge/Platforms-macOS-F05138)

- Swift 6.1+
- Platforms:
    - macOS 10.15+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-mail-driver-memory", .upToNextMinor(from: "1.0.0-beta.1")),
```

Then add `FeatherMailDriverMemory` to your target dependencies:

```swift
.product(name: "FeatherMailDriverMemory", package: "feather-mail-driver-memory"),
```

## Usage

![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)

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

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Related repositories

- [Feather Mail](https://github.com/feather-framework/feather-mail)
- [Feather Mail Driver SMTP](https://github.com/feather-framework/feather-mail-driver-smtp)
- [Feather Mail Driver SES](https://github.com/feather-framework/feather-mail-driver-ses)

## Development

- Build: `swift build`
- Test:
    - local: `make test`
    - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-mail-driver-memory/pulls) are welcome. Please keep changes focused and include tests for new logic.
