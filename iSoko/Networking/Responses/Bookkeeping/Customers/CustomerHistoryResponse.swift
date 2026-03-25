//
//  CustomerHistoryResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct CustomerHistoryResponse: Codable {
    public let customer: CustomerResponse?
    public let sales: Int?
    public let amount: Double?
}
