//
//  UserRegistrationResponse.swift
//  
//
//  Created by Edwin Weru on 03/02/2026.
//

public struct UserRegistrationResponse: Codable {
    public let id: String
    public let ageGroup: IDNamePairInt?
    public let lastName: String
    public let firstName: String
    public let country: IDNamePairInt
    public let status: String
    public let verified: Bool
    public let middleName: String?
    public let location: IDNamePairInt
    public let username: String?
    public let role: IDNamePairInt
    public let profileImage: String?
    public let referralCode: String
    public let email: String
    public let phoneNumber: String
    public let gender: IDNamePairInt
}
