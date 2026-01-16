//
//  MemoryMail.swift
//  feather-mail-driver-memory
//
//  Created by Tibor Bödecs on 2026. 01. 15..
//

import Foundation
import FeatherMail

/// An in-memory, actor-isolated mailbox used for testing and development.
///
/// `MemoryMail` validates incoming mail using a `MailValidating`
/// implementation before storing it. This mirrors the behavior of
/// real mail drivers, where validation occurs prior to delivery.
///
/// Stored mails are kept in insertion order and are not persisted.
final actor MemoryMail {

    /// Stored mails in the order they were added.
    private var delivered: [Mail]

    /// Validator used to validate mails before storage.
    private let validator: MailValidating

    /// Creates a new in-memory mailbox.
    ///
    /// - Parameter validator: The validator used to validate mails
    ///   before they are stored. Defaults to `DefaultMailValidator`.
    init(
        validator: MailValidating = DefaultMailValidator()
    ) {
        self.delivered = []
        self.validator = validator
    }

    /// Returns all delivered mails.
    ///
    /// - Returns: A snapshot of the mailbox contents.
    func getMailbox() -> [Mail] {
        delivered
    }

    /// Validates and stores a mail.
    ///
    /// - Parameter mail: The mail to validate and store.
    /// - Throws: `MailError` if validation fails.
    func add(_ mail: Mail) throws(MailError) {
        try validator.validate(mail)
        delivered.append(mail)
    }

    /// Removes all stored mails from the mailbox.
    func clear() {
        delivered.removeAll()
    }
}
