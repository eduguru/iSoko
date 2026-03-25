//
//  CustomerOrderResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct CustomerOrderResponse: Codable {
    public let id: Int
    public let orderDate: String?
    public let orderNumber: String?
    public let orderAmount: Double?
    public let paymentMethod: String?
    public let products: [CustomerProductResponse]?
}
