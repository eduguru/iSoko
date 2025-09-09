//
//  TradeServiceTypeResponse.swift
//  
//
//  Created by Edwin Weru on 09/09/2025.
//

public struct TradeServiceTypeResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let imageUrl: String?
    let marketServiceCategoryId: Int?
    let marketServiceCategoryName: String?
}
