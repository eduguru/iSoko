//
//  CommoditySubCategoryResponse.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

public struct CommoditySubCategoryResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let imageUrl: String?
    let commodityCategoryId: Int?
    let commodityCategoryName: String?
    let isActive: Bool?
    let addedBy: Int?
    let dateAdded: Int64?
}
