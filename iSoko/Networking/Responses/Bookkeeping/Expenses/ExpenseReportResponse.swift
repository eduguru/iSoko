//
//  ExpenseReportResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct ExpenseReportResponse: Codable {
    public let transactions: Int?
    public let amount: Double?
    public let history: [ExpenseHistoryResponse]?
}
