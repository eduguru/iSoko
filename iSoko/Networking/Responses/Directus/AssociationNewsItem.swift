//
//  AssociationNewsItem.swift
//  
//
//  Created by Edwin Weru on 29/04/2026.
//

import Foundation

struct DirectusNewsItem: Decodable {
    let id: Int
    let title: String?
    let body: String?
    let status: String?
    let createdOn: String?
    let newsCategory: NewsCategory?
    let featuredImage: FeaturedImage?

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

struct NewsCategory: Decodable {
    let key: Int?
    let collection: String?
}

struct FeaturedImage: Decodable {
    let id: String
    let filenameDisk: String?

    enum CodingKeys: String, CodingKey {
        case id
        case filenameDisk = "filename_disk"
    }
}

extension FeaturedImage {
    func url(baseURL: URL) -> URL {
        baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(id)
    }
}

struct AssociationNewsItem: Decodable {
    let id: Int
    let associationId: Int?
    let createdOn: String?
    let modifiedOn: String?
    let newsCategory: String?
    let newsContent: String?
    let newsTitle: String?
    let visibility: String?
    let featuredImage: AssociationFeaturedImage?

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
