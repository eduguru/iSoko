//
//  UserProfile.swift
//  
//
//  Created by Edwin Weru on 18/11/2025.
//

public struct UserProfile: Codable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let middleName: String?
    public let lastName: String
    public let phoneNumber: String
    public let username: String
    public let profileImage: String?
    public let gender: IDNamePairInt
    public let ageGroup: IDNamePairInt
    public let role: IDNamePairInt
    public let location: IDNamePairString
    public let country: IDNamePairInt
    public let status: String
    public let verified: Bool
    public let datetimeCreated: String
}
