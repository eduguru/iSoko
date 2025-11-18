//
//  RegistrationRequest.swift
//
//
//  Created by Edwin Weru on 21/08/2025.
//

public struct RegistrationRequest: Codable {
    // Common
    public let email: String
    public let phoneNumber: String
    public let password: String
    public let confirmPassword: String
    public let country: IDNamePairInt
    public let languagePreference: Int?
    public let location: IDNamePairString
    public let verificationMode: String
    public let role: IDNamePairInt
    public let firstName: String
    public let middleName: String?
    public let lastName: String
    public let gender: IDNamePairInt
    public let otpRequestId: String
    public let code: String
    public let referralCode: String?

    // Organization-only
    public let isOrganization: Bool
    public let organizationName: String?
    public let organizationType: IDNamePairInt?
    public let organizationSize: IDNamePairInt?
    public let postalAddress: String?
    public let physicalAddress: String?
    public let website: String?
}
