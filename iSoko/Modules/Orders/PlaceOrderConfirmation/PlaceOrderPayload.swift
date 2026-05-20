//
//  PlaceOrderPayload.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//

struct PlaceOrderPayload {
    let product: ProductResponseV1
    let quantity: Int
    let minimumQuantity: Int
    let unitName: String?
    let unitPrice: Double?
}
