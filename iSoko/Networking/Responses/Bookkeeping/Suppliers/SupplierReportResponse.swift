//
//  SupplierReportResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct SupplierReportResponse: Codable {
    public let suppliers: Int
    public let amount: Double?
    public let history: [SupplierHistoryResponse]?
}
