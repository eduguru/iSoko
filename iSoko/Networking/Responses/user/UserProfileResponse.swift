//
//  UserProfileResponse.swift
//  
//
//  Created by Edwin Weru on 19/05/2026.
//

public struct UserProfileResponse: Codable {
    public let id: Int              
    public let ageGroup: IDNamePairInt?
    public let lastName: String?
    public let firstName: String?
    public let country: IDNamePairInt?
    public let status: String?
    public let verified: Bool?
    public let middleName: String?
    public let location: IDNamePairInt?
    public let username: String?
    public let role: IDNamePairInt
    public let profileImage: String?
    public let referralCode: String?
    public let email: String?
    public let phoneNumber: String?
    public let gender: IDNamePairInt?
}
