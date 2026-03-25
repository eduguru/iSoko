//
//  LogisitcisServiceProviderResponse.swift
//  
//
//  Created by Edwin Weru on 16/03/2026.
//

import Foundation

public struct LogisitcisServiceProviderResponse: Codable {
    public let id: Int
    public let providerName: String?
    public let email: String?
    public let website: String?
    public let phoneNumber: String?
    public let displayImage: String?
    public let locationId: Int?
    public let locationName: String?
    public let countryName: String?
    public let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case providerName
        case email, website
        case phoneNumber
        case displayImage
        case locationId
        case locationName
        case countryName
        case rating
    }

    // Handles rating coming as Int or Double
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        displayImage = try container.decodeIfPresent(String.self, forKey: .displayImage)
        locationId = try container.decodeIfPresent(Int.self, forKey: .locationId)
        locationName = try container.decodeIfPresent(String.self, forKey: .locationName)
        countryName = try container.decodeIfPresent(String.self, forKey: .countryName)

        // Flexible rating decoding
        if let doubleRating = try? container.decode(Double.self, forKey: .rating) {
            rating = doubleRating
        } else if let intRating = try? container.decode(Int.self, forKey: .rating) {
            rating = Double(intRating)
        } else {
            rating = nil
        }
    }
}
