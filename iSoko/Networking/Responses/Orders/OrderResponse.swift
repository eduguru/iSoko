//
//  OrderResponse.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

public struct OrderResponse: Codable {
    let id: Int
    let orderNumber: String
    let amount: Double
    let status: String
    let buyer: OrderUser
    let seller: OrderSeller
    let datetimeCreated: String
}

public struct OrderUser: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
}

public struct OrderSeller: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let location: OrderLocation?
}

public struct OrderLocation: Codable {
    let id: Int
    let name: String
}
