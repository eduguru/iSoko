//
//  UserProfileResponse.swift
//  
//
//  Created by Edwin Weru on 19/05/2026.
//

import Foundation
import UtilsKit

public struct UserProfileResponse: Codable {
    public let id: Int
    public let ageGroup: IDNamePairInt?
    public let lastName: String?
    public let firstName: String?
    public let country: IDNamePairInt?
    public let status: String?
    public let datetimeCreated: String?
    public let verified: Bool?
    public let middleName: String?
    public let referralCount: Int?
    public let location: IDNamePairInt?
    public let username: String?
    public let role: IDNamePairInt
    public let profileImage: String?
    public let referralCode: String?
    public let email: String?
    public let phoneNumber: String?
    public let gender: IDNamePairInt?

    public var memberSinceString: String? {
        guard
            let datetimeCreated,
            let date = Date.fromBackend(datetimeCreated)
        else {
            return nil
        }

        return "\(date.getMonthOfYear())"
    }
}
