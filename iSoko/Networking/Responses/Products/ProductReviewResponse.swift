//
//  ProductReviewResponse.swift
//  
//
//  Created by Edwin Weru on 03/09/2026.
//

public struct ProductReviewResponse: Decodable {
    let reviewer: ProductReviewReviewerResponse?
    let rating: Double?
    let review: String?
    let datetimeCreated: String?
}

public struct ProductReviewReviewerResponse: Decodable {
    let id: Int?
    let email: String?
    let phoneNumber: String?
}
