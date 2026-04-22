//
//  CommodityResponse.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

public struct CommodityResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let imageUrl: String?
    let commodityCategoryId: Int?
    let commodityCategoryName: String?
    let commoditySubCategoryId: Int?
    let commoditySubCategoryName: String?
    let marketPriceMeasurementUnitId: Int?
    let marketPriceMeasurementUnit: String?
    let marketPriceMeasurementMetricId: Int?
    let marketPriceMeasurementMetric: String?
    let tradeStatisticsMeasurementUnitId: Int?
    let tradeStatisticsMeasurementUnit: String?
    let tradeStatisticsMeasurementMetricId: Int?
    let tradeStatisticsMeasurementMetric: String?
}


public struct CommodityV1Response: Decodable {
    let id: Int?
    let name: String?
    let imageUrl: String?
    let subCategory: CommoditySubCategoryResponse?
    let marketPriceUnit: MeasurementUnitResponse?
    let tradeStatisticsUnit: MeasurementUnitResponse?
    let active: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, subCategory, marketPriceUnit, tradeStatisticsUnit, active
        case imageUrl = "url"
    }
}
