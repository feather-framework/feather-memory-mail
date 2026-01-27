//
//  MemoryMailDriverTests.swift
//  feather-mail-driver-memory
//
//  Created by Binary Birds on 2026. 01. 15..

import Testing
@testable import FeatherMailDriverMemory
@testable import FeatherMail

@Suite
struct MemoryMailTests {

    private struct RejectingValidator: MailValidator {
        let error: MailValidationError

        func validate(_ mail: Mail) async throws(MailValidationError) {
            throw error
        }
    }

    // MARK: - Validation

    @Test
    func memoryMail_invalidSenderThrows() async {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("   "),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSender) {
            try await mailbox.add(mail)
        }
    }

    @Test
    func memoryMail_invalidSubjectThrows() async {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "   ",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSubject) {
            try await mailbox.add(mail)
        }
    }

    @Test
    func memoryMail_invalidRecipientThrows() async {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("   ")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidRecipient) {
            try await mailbox.add(mail)
        }
    }

    @Test
    func memoryMail_attachmentsTooLargeThrows() async {
        let validator = BasicMailValidator(
            maxTotalAttachmentSize: 100
        )
        let mailbox = MemoryMail(validator: validator)

        let data = [UInt8](repeating: 0, count: 1_024)

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body"),
            attachments: [
                .init(
                    name: "feather.png",
                    contentType: "image/png",
                    data: data
                )
            ]
        )

        await #expect(throws: MailValidationError.attachmentsTooLarge) {
            try await mailbox.add(mail)
        }
    }

    @Test
    func memoryMail_headerInjectionThrows() async {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello\nInjected",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.headerInjectionDetected) {
            try await mailbox.add(mail)
        }
    }

    @Test
    func memoryMail_customValidatorIsUsed() async {
        let mailbox = MemoryMail(
            validator: RejectingValidator(error: .invalidSubject)
        )

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        await #expect(throws: MailValidationError.invalidSubject) {
            try await mailbox.add(mail)
        }
    }

    // MARK: - Storage behavior

    @Test
    func memoryMail_storesValidMail() async throws {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await mailbox.add(mail)

        let stored = await mailbox.getMailbox()
        #expect(stored.count == 1)
        #expect(stored.first?.subject == "Hello")
    }

    @Test
    func memoryMail_preservesInsertionOrder() async throws {
        let mailbox = MemoryMail()

        let first = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "First",
            body: .plainText("Body")
        )

        let second = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Second",
            body: .plainText("Body")
        )

        try await mailbox.add(first)
        try await mailbox.add(second)

        let stored = await mailbox.getMailbox()
        #expect(stored.map(\.subject) == ["First", "Second"])
    }

    @Test
    func memoryMail_clearRemovesAll() async throws {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await mailbox.add(mail)
        await mailbox.clear()

        let stored = await mailbox.getMailbox()
        #expect(stored.isEmpty)
    }

    @Test
    func memoryMail_validateDoesNotStoreMail() async throws {
        let mailbox = MemoryMail()

        let mail = Mail(
            from: .init("from@example.com"),
            to: [.init("to@example.com")],
            subject: "Hello",
            body: .plainText("Body")
        )

        try await mailbox.validate(mail)

        let stored = await mailbox.getMailbox()
        #expect(stored.isEmpty)
    }

    // MARK: - Concurrency

    @Test
    func memoryMail_isConcurrencySafe() async throws {
        let mailbox = MemoryMail()

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<100 {
                group.addTask {
                    let mail = Mail(
                        from: .init("from@example.com"),
                        to: [.init("to@example.com")],
                        subject: "Mail \(i)",
                        body: .plainText("Body")
                    )
                    try! await mailbox.add(mail)
                }
            }
        }

        let stored = await mailbox.getMailbox()
        #expect(stored.count == 100)
    }
}
