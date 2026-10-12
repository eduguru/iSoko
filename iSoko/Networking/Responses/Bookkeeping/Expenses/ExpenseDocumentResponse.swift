//
//  ExpenseDocumentResponse.swift
//
//  Response item for POST /bookkeeping/expenses/{id}/expense-documents.
//  All fields optional so a schema drift never breaks the upload flow.
//

import Foundation

public struct ExpenseDocumentResponse: Decodable {
    public let id: Int?
    public let url: String?
    public let active: Bool?
}
