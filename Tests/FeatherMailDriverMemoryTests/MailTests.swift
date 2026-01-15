//
//  MailTests.swift
//  feather-mail-driver-memory
//
//  Created by Binary Birds on 2026. 01. 15..

import Testing
@testable import FeatherMail

// MARK: - Helpers

extension Mail {

    static func valid(
        from: String = "sender@example.com",
        to: String = "user@example.com",
        subject: String = "Hello"
    ) throws -> Mail {
        try Mail(
            from: .init(from),
            to: [.init(to)],
            subject: subject,
            body: .plainText("Body")
        )
    }
}

// MARK: - Mail Validation Tests

@Test
func mailInvalidSender() {
    #expect(throws: MailError.invalidSender) {
        try Mail(
            from: .init("   "),
            to: [.init("user@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )
    }
}

@Test
func mailInvalidSubject() {
    #expect(throws: MailError.invalidSubject) {
        try Mail(
            from: .init("sender@example.com"),
            to: [.init("user@example.com")],
            subject: "   ",
            body: .plainText("Body")
        )
    }
}

@Test
func mailInvalidRecipient() {
    #expect(throws: MailError.invalidRecipient) {
        try Mail(
            from: .init("sender@example.com"),
            to: [.init("   ")],
            subject: "Hello",
            body: .plainText("Body")
        )
    }
}

@Test
func mailFiltersInvalidAddresses() throws {
    let mail = try Mail(
        from: .init("sender@example.com"),
        to: [.init("valid@example.com"), .init("   ")],
        cc: [.init(" "), .init("cc@example.com")],
        subject: "Hello",
        body: .plainText("Body")
    )

    #expect(mail.to.count == 1)
    #expect(mail.cc.count == 1)
    #expect(mail.to.first?.email == "valid@example.com")
    #expect(mail.cc.first?.email == "cc@example.com")
}

@Test
func mailValidConstructionSucceeds() throws {
    let mail = try Mail.valid()
    #expect(mail.subject == "Hello")
}
