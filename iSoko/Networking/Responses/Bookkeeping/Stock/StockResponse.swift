//
//  StockResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct StockResponse: Codable {
    public let id: Int
    public let name: String?
    public let quantity: Int
    public let price_per_unit: Double?
    public let date_added: String?
    public let measurement_unit: String?
    public let supplier: SupplierResponse?
    public let lowStockAlert: Int?
    public let criticalStockAlert: Int?
}
