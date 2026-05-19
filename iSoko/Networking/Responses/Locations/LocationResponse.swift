//
//  LocationResponse.swift
//
//
//  Created by Edwin Weru on 27/08/2025.
//

import Foundation

public struct LocationResponse: Decodable {
    let id: Int?
    let name: String?
    let code: String?
    let level: IDNamePairInt?
    let parent: IDNamePairInt?
    let country: IDNamePairInt?
    let active: Bool?
    let datetimeCreated: String?
    
    // Computed property to convert string -> Date
    public var createdDate: Date? {
        guard let datetimeCreated else { return nil }
        
        // ISO8601 with fractional seconds
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return formatter.date(from: datetimeCreated)
    }
}
