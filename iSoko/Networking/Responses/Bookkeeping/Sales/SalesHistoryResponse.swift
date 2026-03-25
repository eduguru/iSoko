//
//  SalesHistoryResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct SalesHistoryResponse: Codable {
    public let customer: CustomerResponse?
    public let amount: Double?
    public let items: Int?
    public let date: String?
}
