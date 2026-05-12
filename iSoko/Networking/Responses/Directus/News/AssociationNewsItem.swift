//
//  AssociationNewsItem.swift
//  
//
//  Created by Edwin Weru on 29/04/2026.
//

import Foundation

struct AssociationNewsItem: Decodable {
    let id: Int
    let associationId: Int?
    let createdOn: String?
    let modifiedOn: String?
    let newsCategory: String?
    let newsContent: String?
    let newsTitle: String?
    let visibility: String?
    let featuredImage: NewsImage?

    enum CodingKeys: String, CodingKey {
        case id
        case associationId = "association_id"
        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case newsCategory = "news_category"
        case newsContent = "news_content"
        case newsTitle = "news_title"
        case visibility
        case featuredImage = "featured_image"
    }
}
