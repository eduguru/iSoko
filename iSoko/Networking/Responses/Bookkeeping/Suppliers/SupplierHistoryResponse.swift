//
//  SupplierHistoryResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct SupplierHistoryResponse: Codable {
    public let supplier: SupplierResponse?
    public let items: Int?
    public let amount: Double?
}
