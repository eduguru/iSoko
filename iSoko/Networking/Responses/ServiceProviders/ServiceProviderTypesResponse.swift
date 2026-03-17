//
//  ServiceProviderTypesResponse.swift
//  
//
//  Created by Edwin Weru on 17/03/2026.
//

import Foundation

public struct ServiceProviderTypesResponse: Codable {
    public let id: Int
    public let providerType: String
    public let isActive: Bool?
    public let noOfProviders: Int?
}
