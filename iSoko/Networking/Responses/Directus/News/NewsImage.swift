//
//  NewsImage.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import Foundation

struct NewsImage: Decodable {
    let assetIdentifier: String?

    enum CodingKeys: String, CodingKey {
        case id
        case filenameDisk = "filename_disk"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        assetIdentifier =
            try container.decodeIfPresent(String.self, forKey: .id)
            ?? container.decodeIfPresent(String.self, forKey: .filenameDisk)
    }

    func url(baseURL: URL) -> URL? {
        guard let assetIdentifier else { return nil }

        return baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(assetIdentifier)
    }

    func urlString(baseURL: String) -> String? {
        guard
            let assetIdentifier,
            let base = URL(string: baseURL)
        else {
            return nil
        }

        return base
            .appendingPathComponent("assets")
            .appendingPathComponent(assetIdentifier)
            .absoluteString
    }
}
