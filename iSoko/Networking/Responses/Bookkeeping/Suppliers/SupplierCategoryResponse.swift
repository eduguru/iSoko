//
//  SupplierCategoryResponse.swift
//  
//
//  Created by Edwin Weru on 14/04/2026.
//

public struct SupplierCategoryResponse: Codable {
    public let id: Int
    public let name: String?
    public let supplier: SupplierResponse?
}
