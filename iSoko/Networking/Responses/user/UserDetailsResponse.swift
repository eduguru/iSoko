//
//  UserDetailsResponse.swift
//  
//
//  Created by Edwin Weru on 26/08/2025.
//

public struct UserDetailsResponse: Codable {
    let id: Int
    let email: String
    let phoneNumber: String
    let profileImage: String?
    let countryId: Int
    let countryName: String?
    let languageId: Int
    let languageName: String?
    let isActive: Bool?
    let username: String?
    let userTypeId: Int
    let verifiedTrader: Bool?
    let userTypeName: String?
    let locationId: Int
    let locationName: String?
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let genderId: Int
    let genderName: String?
    let roleName: String?
    let roleId: Int
    let roleIsAdmin: Bool
    let dateJoined: Int?
    let rating: Double?
    let appPermissions: [AppPermission]
}
