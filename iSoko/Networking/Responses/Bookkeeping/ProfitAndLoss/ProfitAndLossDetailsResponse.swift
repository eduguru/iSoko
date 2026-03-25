//
//  ProfitAndLossDetailsResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct ProfitAndLossDetailsResponse: Codable {
    public let income: IncomeDetailsResponse?
    public let expenses: [ExpenseDetailResponse]?
}
