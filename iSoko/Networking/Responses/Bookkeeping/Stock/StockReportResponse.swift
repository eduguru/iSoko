//
//  StockReportResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct StockReportResponse: Codable {
    public let availableStock: Int?
    public let value: Double?
    public let profit: Double?
    public let lowStock: Int?
    public let stockIntake: Int?
    public let outOfStock: Int?
    public let stock: [StockReportHistoryResponse]?
}
