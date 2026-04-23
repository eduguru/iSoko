//
//  ExpenseHistoryResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct ExpenseHistoryResponse: Codable {
    public let date: String?
    public let amount: Double?
    
    public let category: IDNamePairInt?
    public let paymentMethod: IDNamePairInt?
}
