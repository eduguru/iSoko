//
//  MarketServiceResponse.swift
//
//  Response item for GET /v1/market-services (nested shape from the API spec).
//  Mapped to the flat `TradeServiceResponse` the screens already use, so no UI changes.
//

import Foundation

public struct MarketServiceResponse: Decodable {
    struct IdName: Decodable {
        let id: Int?
        let name: String?
    }

    struct Trader: Decodable {
        let id: Int?
        let email: String?
        let firstName: String?
        let lastName: String?
    }

    struct Image: Decodable {
        let id: Int?
        let url: String?
        let primary: Bool?
        let active: Bool?
    }

    let id: Int?
    let name: String?
    let description: String?
    let serviceType: IdName?
    let price: Double?
    let minimumOrderQuantity: Int?
    let measurementUnit: IdName?
    let trader: Trader?
    let approved: Bool?
    let published: Bool?
    let featured: Bool?
    let images: [Image]?
}

extension MarketServiceResponse {
    func toTradeService() -> TradeServiceResponse {
        let activeImages = (images ?? []).filter { $0.active != false }
        let primary = activeImages.first(where: { $0.primary == true }) ?? activeImages.first
        let traderName = [trader?.firstName, trader?.lastName]
            .compactMap { $0 }
            .joined(separator: " ")

        return TradeServiceResponse(
            id: id,
            name: name,
            description: description,
            minimumOrderQuantity: minimumOrderQuantity,
            marketServiceTypeId: serviceType?.id,
            categoryId: nil,                 // not part of MarketServiceResponse
            serviceTypeName: serviceType?.name,
            categoryName: nil,
            measurementUnit: measurementUnit?.name,
            measurementUnitId: measurementUnit?.id,
            measurementMetric: nil,
            measurementMetricId: nil,
            primaryImage: primary?.url,
            traderName: traderName.isEmpty ? nil : traderName,
            traderVerified: nil,
            traderId: trader?.id,
            isApproved: approved,
            dateAdded: nil,
            isPublished: published,
            isFeatured: featured,
            locationName: nil,
            price: price,
            images: activeImages.compactMap { $0.url }
        )
    }
}
