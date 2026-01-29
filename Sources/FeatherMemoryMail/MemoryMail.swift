//
//  MemoryMail.swift
//  feather-memory-mail
//
//  Created by Tibor Bödecs on 2026. 01. 15..
//

import FeatherMail

/// An in-memory, actor-isolated mailbox used for testing and development.
///
/// `MemoryMail` validates incoming mail using a `MailValidator`
/// implementation before storing it. This mirrors the behavior of
/// real mail drivers, where validation occurs prior to delivery.
///
/// Stored mails are kept in insertion order and are not persisted.
public actor MemoryMail {

    /// Stored mails in the order they were added.
    private var delivered: [Mail]

    /// Validator used to validate mails before storage.
    private let validator: MailValidator

    /// Creates a new in-memory mailbox.
    ///
    /// - Parameter validator: The validator used to validate mails
    ///   before they are stored. Defaults to `BasicMailValidator`.
    public init(
        validator: MailValidator = BasicMailValidator()
    ) {
        self.delivered = []
        self.validator = validator
    }

    /// Returns all delivered mails.
    ///
    /// - Returns: A snapshot of the mailbox contents.
    public func getMailbox() -> [Mail] {
        delivered
    }

    /// Validates and stores a mail.
    ///
    /// - Parameter mail: The mail to validate and store.
    /// - Throws: `MailValidationError` if validation fails.
    public func add(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
        delivered.append(mail)
    }

    /// Validates a mail without storing it.
    ///
    /// - Parameter mail: The mail to validate.
    /// - Throws: `MailValidationError` if validation fails.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
    }

    /// Removes all stored mails from the mailbox.
    public func clear() {
        delivered.removeAll()
    }
}
