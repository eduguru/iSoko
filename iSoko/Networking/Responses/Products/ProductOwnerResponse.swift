//
//  ProductOwnerResponse.swift
//
//
//  Created by Edwin Weru on 28/08/2025.
//

public struct ProductOwnerResponse: Decodable {
    let id: Int?
    let email: String?
    let phoneNumber: String?
    let profileImage: String?
    let countryId: Int?
    let countryName: String?
    let languageId: Int?
    let languageName: String?
    let isActive: Bool?
    let username: String?
    let locationId: Int?
    let locationName: String?
    let userTypeId: Int?
    let verifiedTrader: Bool?
    let userTypeName: String?
    let roleId: Int?
    let roleName: String?
    let roleIsAdmin: Bool?
    let rating: Double?
    let dateJoined: Int?
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let genderId: Int?
    let genderName: String?
}
