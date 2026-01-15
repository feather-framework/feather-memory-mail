//
//  MemoryMailDriver.swift
//  feather-mail-driver-memory
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import FeatherMail

/// An in-memory mail driver implementation.
///
/// `MemoryMailDriver` conforms to `MailProtocol` and delivers mails
/// to an in-memory, actor-isolated mailbox. It is intended for:
/// - testing
/// - previews
/// - local development
///
/// This driver never performs network operations and does not persist data.
/// All stored mails are lost when the process terminates.
public struct MemoryMailDriver: Sendable {

    /// Actor-backed mailbox used to store delivered mails.
    ///
    /// Each `MemoryMailDriver` instance owns its own isolated mailbox.
    private let memoryMail: MemoryMail = .init()
}

extension MemoryMailDriver: MailProtocol {

    /// Sends a mail by storing it in memory.
    ///
    /// - Parameter email: A pre-validated `Mail` instance.
    /// - Throws: `MailError` only if required by `MailProtocol`.
    ///   This implementation never fails during delivery.
    public func send(_ email: Mail) async throws(MailError) {
        await memoryMail.add(email)
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
