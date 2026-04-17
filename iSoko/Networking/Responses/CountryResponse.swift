//
//  CountryResponse.swift
//  
//
//  Created by Edwin Weru on 17/04/2026.
//

// Country model
public struct CountryResponse: Codable {
    public let id: Int
    public let name: String?
    public let code: String?
    public let defaultLanguage: CommonIdNameResponse?
}
