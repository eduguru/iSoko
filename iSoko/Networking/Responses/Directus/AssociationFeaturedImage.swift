//
//  AssociationFeaturedImage.swift
//  
//
//  Created by Edwin Weru on 29/04/2026.
//

import Foundation


struct AssociationFeaturedImage: Decodable {
    let filenameDisk: String?

    enum CodingKeys: String, CodingKey {
        case filenameDisk = "filename_disk"
    }

    func url(baseURL: URL) -> URL? {
        guard let id = filenameDisk else { return nil }
        return baseURL.appendingPathComponent("assets").appendingPathComponent(id)
    }

    func url2(baseURL: URL) -> URL? {
        guard let filename = filenameDisk else { return nil }
        return baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(filename)
    }
}
