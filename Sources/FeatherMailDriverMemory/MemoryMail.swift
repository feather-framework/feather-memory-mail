//
//  MemoryMail.swift
//  feather-mail-driver-memory
//
//  Created by Tibor Bodecs on 19/11/2023.
//

import Foundation
import FeatherMail

/// An in-memory, actor-isolated mailbox used for testing and development.
///
/// `MemoryMail` provides a thread-safe storage for delivered `Mail` values.
/// It guarantees:
/// - serialized access to internal state via Swift Concurrency
/// - preservation of insertion order
/// - no persistence beyond process lifetime
///
/// This type is intentionally simple and is not intended for production use.
final actor MemoryMail {

    /// Stored mails in the order they were added.
    private var delivered: [Mail]

    /// Creates an empty in-memory mailbox.
    init() {
        self.delivered = []
    }

    /// Returns all delivered mails.
    ///
    /// - Returns: A snapshot of the current mailbox contents.
    func getMailbox() -> [Mail] {
        delivered
    }

    /// Adds a new mail to the mailbox.
    ///
    /// - Parameter mail: A validated `Mail` instance to store.
    func add(_ mail: Mail) {
        delivered.append(mail)
    }

    /// Removes all stored mails from the mailbox.
    func clear() {
        delivered.removeAll()
    }
}
