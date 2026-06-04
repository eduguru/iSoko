//
//  ApiConfig.swift
//  
//
//  Created by Edwin Weru on 04/06/2026.
//

import Foundation

struct ApiConfig: Decodable {
    let development: DevelopmentConfig
    let countries: [String: CountryConfig]
}

struct DevelopmentConfig: Decodable {
    let apiEndpoint: String
    let websiteUrl: String
    let directusUrl: String
    let directusUsername: String
    let directusPassword: String
    let grantType: String
    let clientId: String
    let clientSecret: String
}

struct CountryConfig: Decodable {
    let countryName: String
    let currency: String

    let apiEndpoint: String
    let websiteUrl: String

    let directusUrl: String
    let directusUsername: String
    let directusPassword: String
}
