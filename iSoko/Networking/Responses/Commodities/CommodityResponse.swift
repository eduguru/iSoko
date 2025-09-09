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
