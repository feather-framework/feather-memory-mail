# Feather Memory Mail

In-memory mail client for Feather Mail, designed for tests and local development.
It mirrors the behavior of real mail transports (SMTP, SES) without performing any network operations.

[![Release: 1.0.0-beta.1](https://img.shields.io/badge/Release-1.0.0--beta.1-F05138)](
    https://github.com/feather-framework/feather-memory-mail/releases/tag/1.0.0-beta.1
)

## Features

- In-memory mailbox with insertion-order storage
- Validates mail before storage
- Supports plain text, HTML, and attachments
- No network dependencies

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.1+
- Platforms:
  - macOS 15+
  - iOS 18+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-memory-mail", exact: from: "1.0.0-beta.1"),
```

Then add `FeatherMemoryMail` to your target dependencies:

```swift
.product(name: "FeatherMemoryMail", package: "feather-memory-mail"),
```

## Usage

[![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)](
    https://feather-framework.github.io/feather-memory-mail/
)

API documentation is available at the following link.

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

### Example

```swift
let client = MemoryMailClient()

let mail = Mail(
    from: .init("from@example.com"),
    to: [.init("to@example.com")],
    subject: "Hello",
    body: .plainText("Body")
)

try await client.send(mail)

let mailbox = await client.getMailbox()
```

## Related repositories

- [Feather Mail](https://github.com/feather-framework/feather-mail)
- [Feather SMTP Mail](https://github.com/feather-framework/feather-smtp-mail)
- [Feather SES Mail](https://github.com/feather-framework/feather-ses-mail)

## Development

- Build: `swift build`
- Test:
  - local: `make test`
  - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-memory-mail/pulls) are welcome. Please keep changes focused and include tests for new logic.
