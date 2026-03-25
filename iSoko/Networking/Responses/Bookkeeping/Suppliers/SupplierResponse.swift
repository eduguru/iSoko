//
//  SupplierResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct SupplierResponse: Codable {
    public let id: Int
    public let name: String?
    public let phoneNumber: String?
    public let email: String?
    public let streetAddress: String?
    public let country: IDNamePairInt?
    public let category: IDNamePairInt?
    public let town: String?
    
    /// Optional backend-calculated fields
    public let totalAmountSupplied: Double?
    public let suppliesCount: Int?
}
