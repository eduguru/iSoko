//
//  UpdateProductDto.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

public struct UpdateProductDto: Codable {
    let id: Int
    let name: String?
    let price: Double?
    let description: String?
    let measurementUnitId: Int?
    let minimumOrderQuantity: Int?
    let commodityId: Int?
    let categoryId: Int?
    let subCategoryId: Int?
    
}
