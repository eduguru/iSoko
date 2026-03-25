//
//  SalesReportResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct SalesReportResponse: Codable {
    public let sales: Int
    public let revenue: Double?
    public let history: [SalesHistoryResponse]?
}
