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
    public let phoneNumberCountry: IDNamePairInt?
    public let password: String
    public let confirmPassword: String
    public let languagePreference: Int?
    public let verificationMode: String
    public let country: IDNamePairInt
    public let location: IDNamePairString
    public let role: IDNamePairInt
    public let gender: IDNamePairInt
    public let ageGroup: IDNamePairInt
    public let firstName: String
    public let middleName: String?
    public let lastName: String
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
    
    public func mapToCreateUserRequest() -> CreateUserRequestDto {
        return CreateUserRequestDto(
            ageGroupId: ageGroup.id ?? 0,
            countryId: country.id ?? 0,
            email: email,
            firstName: firstName,
            genderId: 1,
            middleName: middleName,
            lastName: lastName,
            locationId: location.id ?? "",
            password: password,
            phoneNumber: phoneNumber,
            referralCode: referralCode,
            roleId: role.id ?? 0
            )
    }
}

public struct CreateUserRequestDto: Codable {
    public var ageGroupId: Int
    public var countryId: Int
    public var email: String
    public var firstName: String
    public var genderId: Int
    public var middleName: String?
    public var lastName: String
    public var locationId: String
    public var password: String
    public var phoneNumber: String
    public var referralCode: String?
    public let roleId: Int
}
