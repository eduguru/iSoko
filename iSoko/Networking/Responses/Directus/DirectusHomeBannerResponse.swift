//
//  DirectusHomeBannerResponse.swift
//  
//
//  Created by Edwin Weru on 29/04/2026.
//

import Foundation

struct DirectusHomeBannerResponse: Decodable {
    let data: [DirectusHomeBannerItem]
}

struct DirectusHomeBannerItem: Decodable {
    let btnText: String?
    let btnUrl: String?
    let status: String?
    let title: String?
    let imageLink: HomeBannerImage?

    enum CodingKeys: String, CodingKey {
        case btnText = "btn_text"
        case btnUrl = "btn_url"
        case status
        case title
        case imageLink = "image_link"
    }
}

struct HomeBannerImage: Decodable {
    let filenameDisk: String?

    enum CodingKeys: String, CodingKey {
        case filenameDisk = "filename_disk"
    }

    func url(baseURL: URL) -> URL? {
        guard let filenameDisk else { return nil }
        return baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(filenameDisk)
    }

    // NEW: String version
    func url(baseURL: String) -> URL? {
        guard let filenameDisk,
              let base = URL(string: baseURL) else { return nil }
        
        return base
            .appendingPathComponent("assets")
            .appendingPathComponent(filenameDisk)
    }
}
