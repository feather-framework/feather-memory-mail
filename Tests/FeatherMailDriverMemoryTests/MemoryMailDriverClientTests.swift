//
//  MemoryMailDriverClientTests.swift
//  feather-memory-mail
//
//  Created by Binary Birds on 2026. 01. 15..

import Testing
@testable import FeatherMailDriverMemory
@testable import FeatherMail

@Suite
struct MemoryMailDriverClientTests {

    private struct RejectingValidator: MailValidator {
        let error: MailValidationError

        func validate(_ mail: Mail) async throws(MailValidationError) {
            throw error
        }
    }

    @Test
    func driverSendStoresMail() async throws {
        let driver = MemoryMailDriver()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await driver.send(mail)
        let stored = await driver.getMailbox()
        #expect(stored.count == 1)
        #expect(stored.first?.subject == "Hello")
    }

    @Test
    func driverValidateDoesNotThrowForValidMail() async throws {
        let driver = MemoryMailDriver()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Valid",
            body: .plainText("Body")
        )

        try await driver.validate(mail)
    }

    @Test
    func driverValidateThrowsForInvalidMail() async {
        let driver = MemoryMailDriver()
        let mail = Mail(
            from: .init(" "),
            to: [.init("to@example.com")],
            subject: "Invalid",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSender) {
            try await driver.validate(mail)
        }
    }

    @Test
    func driverClearMailboxRemovesAll() async throws {
        let driver = MemoryMailDriver()
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await driver.send(mail)
        await driver.clearMailbox()
        let stored = await driver.getMailbox()
        #expect(stored.isEmpty)
    }

    @Test
    func driverSendUsesInjectedValidator() async throws {
        let mailbox = MemoryMail(
            validator: RejectingValidator(error: .invalidSubject)
        )
        let driver = MemoryMailDriver(memoryMail: mailbox)
        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        do {
            try await driver.send(mail)
            #expect(Bool(false))
        }
        catch let error {
            #expect(error == .validation(.invalidSubject))
        }

        let stored = await driver.getMailbox()
        #expect(stored.isEmpty)
    }
}
