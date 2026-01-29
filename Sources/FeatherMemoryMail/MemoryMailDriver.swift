//
//  MemoryMailDriver.swift
//  feather-memory-mail
//
//  Created by Tibor Bödecs on 2020. 04. 28..
//

import FeatherMail

/// An in-memory mail driver implementation.
///
/// `MemoryMailDriver` conforms to `MailClient` and delivers mails to an
/// actor-isolated `MemoryMail` instance. Incoming mails are validated
/// before being stored, mirroring the behavior of real mail transports.
///
/// This driver is intended for testing, previews, and local development.
/// It does not perform network operations and does not persist data.
public struct MemoryMailDriver: Sendable {

    /// The underlying in-memory mailbox used for validated storage.
    private let memoryMail: MemoryMail

    /// Creates a new in-memory mail driver.
    ///
    /// - Parameter memoryMail: The mailbox instance used for storage.
    ///   Defaults to a new `MemoryMail` instance.
    public init(memoryMail: MemoryMail = MemoryMail()) {
        self.memoryMail = memoryMail
    }
}

extension MemoryMailDriver: MailClient {

    /// Sends a mail by storing it in memory.
    ///
    /// - Parameter mail: The mail to validate and store.
    /// - Throws: `MailError` if validation fails.
    public func send(_ mail: Mail) async throws(MailError) {
        do {
            try await memoryMail.add(mail)
        }
        catch {
            throw .validation(error)
        }
    }

    /// Validates a mail using the in-memory validator.
    ///
    /// - Parameter mail: The mail to validate.
    /// - Throws: `MailValidationError` when validation fails.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await memoryMail.validate(mail)
    }
}

extension MemoryMailDriver {

    /// Returns all mails currently stored in the mailbox.
    ///
    /// - Returns: A snapshot of delivered mails in insertion order.
    public func getMailbox() async -> [Mail] {
        await memoryMail.getMailbox()
    }

    /// Removes all mails from the mailbox.
    public func clearMailbox() async {
        await memoryMail.clear()
    }
}
