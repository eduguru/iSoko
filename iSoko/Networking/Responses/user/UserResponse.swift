//
//  UserResponse.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import Foundation

// MARK: - User Response
public struct UserV1Response: Codable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let middleName: String?          // Nullable in JSON
    public let lastName: String
    public let phoneNumber: String
    public let username: String?            // Nullable
    public let profileImage: String?        // Nullable
    public let gender: IDNamePairInt
    public let ageGroup: IDNamePairInt
    public let role: IDNamePairInt
    public let location: IDNamePairInt
    public let country: IDNamePairInt
    public let verified: Bool
    public let referralCode: String?
    public let status: String
}
