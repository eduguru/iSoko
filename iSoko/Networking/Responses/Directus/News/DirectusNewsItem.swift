//
//  DirectusNewsItem.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import Foundation

struct DirectusNewsItem: Decodable {
    let id: Int
    let title: String?
    let body: String?
    let status: String?
    let createdOn: String?
    let newsCategory: NewsCategory?
    let featuredImage: NewsImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case body = "Body"
        case status
        case createdOn = "created_on"
        case newsCategory = "News_Category"
        case featuredImage = "Featured_Image"
    }
}
