//
//  ProductSummaryModel.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

struct ProductSummaryModel {
    let title: String
    let rating: Double
    let reviewCount: Int
    let location: String
    let priceText: String
    let oldPriceText: String?   // Optional, for strikethrough old price
    let discountText: String?   // Optional, e.g. "21% OFF"
}
