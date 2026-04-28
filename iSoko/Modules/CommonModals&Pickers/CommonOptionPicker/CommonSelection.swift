//
//  CommonSelection.swift
//  
//
//  Created by Edwin Weru on 24/09/2025.
//

enum CommonSelection {
    case idName(CommonIdNameModel)
    case location(LocationResponse)
    case countries(CountryResponse)
    case organisationSize(OrganisationSizeResponse)
    case organisationType(OrganisationTypeResponse)
    case commodityCategories(CommodityCategoryResponse)
    case commodities(CommodityV1Response)
    case products(StockResponse)
    
}
