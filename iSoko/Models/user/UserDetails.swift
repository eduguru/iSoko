//
//  UserDetails.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

public struct UserDetails: Codable {
    let sub: Int
    let name: String
    let email: String
    let verified: Bool
    let phoneNumber: String?
    let roles: [UserRole]

    enum CodingKeys: String, CodingKey {
        case sub
        case name
        case email
        case verified
        case roles
        case phoneNumber = "phone_number"
    }
}

public struct UserRole: Codable {
    let id: Int
    let name: String
}
