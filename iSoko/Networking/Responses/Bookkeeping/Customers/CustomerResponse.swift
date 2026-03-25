//
//  CustomerResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct CustomerResponse: Codable {
    public let id: Int
    public let name: String?
    public let phoneNumber: String?
    public let email: String?
    public let country: IDNamePairInt?
    public let town: String?
    public let streetAddress: String?
    
    /// Optional backend-calculated fields
    public let purchasesTotalAmount: Double?
    public let purchasesCount: Int?
}
