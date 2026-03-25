//
//  ProfitAndLossReportResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct ProfitAndLossReportResponse: Codable {
    public let income: Double?
    public let costOfGoods: Double?
    public let grossProfit: Double?
    public let operatingCosts: Double?
    public let details: ProfitAndLossDetailsResponse?
}
