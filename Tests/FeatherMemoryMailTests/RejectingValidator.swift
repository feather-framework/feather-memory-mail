//
//  RejectingValidator.swift
//  feather-memory-mail
//
//  Created by Binary Birds on 2026. 02. 01..

import FeatherMail

struct RejectingValidator: MailValidator {
    let error: MailValidationError

    func validate(_ mail: Mail) async throws(MailValidationError) {
        throw error
    }
}
