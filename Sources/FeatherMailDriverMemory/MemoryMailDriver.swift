//
//  MemoryMailDriver.swift
//  feather-mail-driver-memory
//
//  Created by Tibor Bödecs on 2020. 04. 28..
//

import Foundation
import FeatherMail

/// An in-memory mail driver implementation.
///
/// `MemoryMailDriver` conforms to `MailProtocol` and delivers mails to an
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
    init(memoryMail: MemoryMail = MemoryMail()) {
        self.memoryMail = memoryMail
    }
}

extension MemoryMailDriver: MailProtocol {

    /// Sends a mail by storing it in memory.
    ///
    /// - Parameter email: A pre-validated `Mail` instance.
    /// - Throws: `MailError` only if required by `MailProtocol`.
    ///   This implementation never fails during delivery.
    public func send(_ email: Mail) async throws(MailError) {
        try await memoryMail.add(email)
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
