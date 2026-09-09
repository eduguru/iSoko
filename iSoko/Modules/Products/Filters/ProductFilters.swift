//
//  ProductFilters.swift
//  
//
//  Created by Edwin Weru on 09/09/2026.
//

public struct ProductFilters {
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var categoryId: Int? = nil
    var categoryName: String? = nil
    var associationId: Int? = nil
    var associationName: String? = nil
    var locationId: Int? = nil
    var locationName: String? = nil

    var isEmpty: Bool {
        minPrice == nil &&
        maxPrice == nil &&
        categoryId == nil &&
        associationId == nil &&
        locationId == nil
    }
}
