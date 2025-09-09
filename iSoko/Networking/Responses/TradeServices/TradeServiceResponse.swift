//
//  TradeServiceResponse.swift
//
//
//  Created by Edwin Weru on 09/09/2025.
//

public struct TradeServiceResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let minimumOrderQuantity: Int?
    let marketServiceTypeId: Int?
    let categoryId: Int?
    let serviceTypeName: String?
    let categoryName: String?
    let measurementUnit: String?
    let measurementUnitId: Int?
    let measurementMetric: String?
    let measurementMetricId: Int?
    let primaryImage: String?
    let traderName: String?
    let traderVerified: Bool?
    let traderId: Int?
    let isApproved: Bool?
    let dateAdded: Int?
    let isPublished: Bool?
    let isFeatured: Bool?
    let locationName: String?
    let price: Double?
}
