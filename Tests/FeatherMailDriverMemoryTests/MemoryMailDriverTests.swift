//
//  MemoryMailDriverTests.swift
//  feather-mail-driver-memory
//
//  Created by Binary Birds on 2026. 01. 15..


import Testing
@testable import FeatherMailDriverMemory
@testable import FeatherMail

@Test
func driverSendStoresMail() async throws {
    let driver = MemoryMailDriver()

    let mail = try Mail.valid()
    try await driver.send(mail)

    let mailbox = await driver.getMailbox()
    #expect(mailbox.count == 1)
}

@Test
func driverPreservesInsertionOrder() async throws {
    let driver = MemoryMailDriver()

    let first = try Mail.valid(subject: "First")
    let second = try Mail.valid(subject: "Second")

    try await driver.send(first)
    try await driver.send(second)

    let mailbox = await driver.getMailbox()
    #expect(mailbox.map(\.subject) == ["First", "Second"])
}

@Test
func driverClearMailboxRemovesAll() async throws {
    let driver = MemoryMailDriver()

    try await driver.send(.valid())
    try await driver.send(.valid(subject: "Another"))

    await driver.clearMailbox()

    let mailbox = await driver.getMailbox()
    #expect(mailbox.isEmpty)
}

@Test
func driverClearEmptyMailboxIsSafe() async {
    let driver = MemoryMailDriver()

    await driver.clearMailbox()

    let mailbox = await driver.getMailbox()
    #expect(mailbox.isEmpty)
}

@Test
func driverSendNeverThrows() async throws {
    let driver = MemoryMailDriver()
    let mail = try Mail.valid()

    try await driver.send(mail)
}

@Test
func driverIsConcurrencySafe() async throws {
    let driver = MemoryMailDriver()

    await withTaskGroup(of: Void.self) { group in
        for i in 0..<100 {
            group.addTask {
                let mail = try! Mail.valid(subject: "Mail \(i)")
                try! await driver.send(mail)
            }
        }
    }

    let mailbox = await driver.getMailbox()
    #expect(mailbox.count == 100)
}
