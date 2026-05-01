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
        guard let filenameDisk = filenameDisk else { return nil }
        return baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(filenameDisk)
    }

    func urlString(baseURL: String) -> String? {
        guard let filenameDisk = filenameDisk, let base = URL(string: baseURL) else { return nil }
        let url = base
            .appendingPathComponent("assets")
            .appendingPathComponent(filenameDisk)
        
        return url.absoluteString
    }
}
