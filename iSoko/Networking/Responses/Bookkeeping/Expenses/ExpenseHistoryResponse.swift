//
//  ExpenseHistoryResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct ExpenseHistoryResponse: Codable {
    public let category: ExpenseResponse?
    public let date: String?
    public let amount: Double?
}
