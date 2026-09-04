//
//  ProductSortOption.swift
//  
//
//  Created by Edwin Weru on 04/09/2026.
//

import Foundation

enum ProductSortOption: String, CaseIterable {
    case nameAZ     = "Name: A → Z"
    case nameZA     = "Name: Z → A"
    case priceLow   = "Price: Low to High"
    case priceHigh  = "Price: High to Low"
    case newest     = "Newest First"
}
