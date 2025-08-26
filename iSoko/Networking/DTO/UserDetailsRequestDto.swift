//
//  UserDetailsRequestDto.swift
//  
//
//  Created by Edwin Weru on 26/08/2025.
//

public struct UserDetailsRequestDto: Codable {
    let email: String
    let countryId: Int
    let languagePreference: Int
    let location: Int
    let role: Int
    let firstName: String
    let middleName: String
    let lastName: String
    let gender: Int
}
