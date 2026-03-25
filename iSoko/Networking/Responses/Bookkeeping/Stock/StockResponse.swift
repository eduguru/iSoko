//
//  StockResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct StockResponse: Codable {
    public let id: Int
    public let name: String
    public let description: String?
    public let price: Double
    public let minimumOrderQuantity: Int
    public let active: Bool
    public let published: Bool
    public let featured: Bool
    public let inStock: Bool
    
    public let category: IDNamePairInt?
    public let commodity: IDNamePairInt?
    public let measurementUnit: IDNamePairInt?
    
    public let trader: TraderResponse?
    public let images: [ImageResponse]?
}

// MARK: - Other Models

public struct TraderResponse: Codable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let lastName: String
}

public struct ImageResponse: Codable {
    public let id: Int
    public let url: String
    public let approved: Bool
    public let primary: Bool
    public let active: Bool
}
