//
//  CreateProductDto.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

public struct CreateProductDto {
    let commodityId: Int?
    let description: String?
    let images: [UploadFile]?
    let isInStock: Bool?
    let isPublished: Bool?
    let languageId: Int?
    let measurementUnitId: Int?
    let minimumOrderQuantity: Int?
    let name: String?
    let price: Double?
    let primaryImage: String?
}
