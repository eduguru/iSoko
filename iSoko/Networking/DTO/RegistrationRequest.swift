//
//  RegistrationRequest.swift
//
//
//  Created by Edwin Weru on 21/08/2025.
//

public protocol RegistrationRequest: Encodable {}

public struct IndividualRegistrationRequest: RegistrationRequest {
    let email: String
    let phoneNumber: String
    let password: String
    let confirmPassword: String
    let country: Int
    let languagePreference: Int
    let location: Int
    let verificationMode: String
    let role: Int
    let firstName: String
    let middleName: String?
    let lastName: String
    let gender: Int
    let otpRequestId: String
    let code: String
    let referralCode: String?
}

public struct OrganizationRegistrationRequest: RegistrationRequest {
    let email: String
    let phoneNumber: String
    let password: String
    let confirmPassword: String
    let country: Int
    let languagePreference: Int
    let location: Int
    let verificationMode: String
    let role: Int
    let organizationName: String
    let organizationType: Int
    let organizationSize: Int
    let postalAddress: String
    let physicalAddress: String
    let website: String?
    let firstName: String
    let middleName: String?
    let lastName: String
    let gender: Int
    let otpRequestId: String
    let code: String
    let referralCode: String?
}
