//
//  FeatherMemoryMailTestSuite.swift
//  feather-memory-mail
//
//  Created by Binary Birds on 2026. 01. 15..

import Testing
import FeatherMail
@testable import FeatherMemoryMail

@Suite
struct FeatherMemoryMailTestSuite {

    @Test
    func clientSendStoresMail() async throws {
        let client = MemoryMailClient()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await client.send(mail)
        let stored = await client.getMailbox()
        #expect(stored.count == 1)
        #expect(stored.first?.subject == "Hello")
    }

    @Test
    func clientValidateDoesNotThrowForValidMail() async throws {
        let client = MemoryMailClient()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Valid",
            body: .plainText("Body")
        )

        try await client.validate(mail)
    }

    @Test
    func clientValidateThrowsForInvalidMail() async {
        let client = MemoryMailClient()
        let mail = Mail(
            from: .init(" "),
            to: [.init("to@example.com")],
            subject: "Invalid",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSender) {
            try await client.validate(mail)
        }
    }

    @Test
    func clientClearMailboxRemovesAll() async throws {
        let client = MemoryMailClient()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await client.send(mail)
        await client.clearMailbox()
        let stored = await client.getMailbox()
        #expect(stored.isEmpty)
    }

    @Test
    func clientSendUsesInjectedValidator() async throws {
        let mailbox = MemoryMail(
            validator: RejectingValidator(error: .invalidSubject)
        )
        let client = MemoryMailClient(memoryMail: mailbox)
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        do {
            try await client.send(mail)
            Issue.record(
                "Expected MailError.validation(.invalidSubject) to be thrown."
            )
        }
        catch {
            if case let .validation(validationError) = error,
                validationError == .invalidSubject
            {
                // Expected path.
            }
            else {
                Issue.record("Unexpected error thrown: \(error)")
            }
        }

        let stored = await client.getMailbox()
        #expect(stored.isEmpty)
    }
}
