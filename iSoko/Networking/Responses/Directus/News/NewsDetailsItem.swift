//
//  NewsDetailsItem.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

struct NewsDetailsItem {
    let id: Int
    let title: String
    let body: String
    let category: String
    let createdOn: String
    let image: NewsImage?
}

extension DirectusNewsItem {
    func toDomain() -> NewsDetailsItem {
        NewsDetailsItem(
            id: id,
            title: title ?? "No Title",
            body: body ?? "",
            category: newsCategory?.collection ?? "Uncategorized",
            createdOn: createdOn ?? "",
            image: featuredImage
        )
    }
}

extension AssociationNewsItem {
    func toDomain() -> NewsDetailsItem {
        NewsDetailsItem(
            id: id,
            title: newsTitle ?? "No Title",
            body: newsContent ?? "",
            category: newsCategory ?? "Uncategorized",
            createdOn: createdOn ?? "",
            image: featuredImage
        )
    }
}
