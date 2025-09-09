//
//  ProductResponse.swift
//
//
//  Created by Edwin Weru on 28/08/2025.
//

public struct ProductResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let minimumOrderQuantity: Int?
    let commodityId: Int?
    let categoryId: Int?
    let subCategoryId: Int?
    let commodityName: String?
    let categoryName: String?
    let subCategoryName: String?
    let measurementUnit: String?
    let measurementUnitId: Int?
    let measurementMetric: String?
    let measurementMetricId: Int?
    let primaryImage: String?
    let traderId: Int?
    let traderName: String?
    let traderVerified:  Bool?
    let locationName: String?
    let isInStock:  Bool?
    let isFeatured:  Bool?
    let discountId: String?
    let discountPrice: String?
    let discountPromoMessage: String?
    let discountUntilDate: String?
    let price: Double?
    
    //MARK: this are additional when you request product based on current user(logged in)
    let measurementMetricIdlet: Int?
    let language: String?
    let isPostToInventory:  Bool?
    let isUpdateSales:  Bool?
    let isApproved:  Bool?
    let dateAdded: Int?
    let isPublished:  Bool?
    let isActive:  Bool?
}
