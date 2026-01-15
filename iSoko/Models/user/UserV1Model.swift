//
//  UserV1Model.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import Foundation

struct UserV1Model: Codable {
    let id: Int
    let email: String
    let firstName: String
    let middleName: String?          // Nullable in JSON
    let lastName: String
    let phoneNumber: String
    let username: String?            // Nullable
    let profileImage: String?        // Nullable
    let gender: IDNamePairInt
    let ageGroup: IDNamePairInt
    let role: IDNamePairInt
    let location: IDNamePairInt
    let country: IDNamePairInt
    let verified: Bool
    let referralCode: String?
    let status: String
    
    init(_ response: UserV1Response) {
        self.id = response.id
        self.email = response.email
        self.firstName = response.firstName
        self.middleName = response.middleName
        self.lastName = response.lastName
        self.phoneNumber = response.phoneNumber
        self.username = response.username
        self.profileImage = response.profileImage
        self.gender = IDNamePairInt(id: response.gender.id, name: response.gender.name)
        self.ageGroup = IDNamePairInt(id: response.ageGroup.id, name: response.ageGroup.name)
        self.role = IDNamePairInt(id: response.role.id, name: response.role.name)
        self.location = IDNamePairInt(id: response.location.id, name: response.location.name)
        self.country = IDNamePairInt(id: response.country.id, name: response.country.name)
        self.verified = response.verified
        self.referralCode = response.referralCode
        self.status = response.status
    }
}

