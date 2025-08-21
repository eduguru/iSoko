//
//  RegistrationBuilder.swift
//  
//
//  Created by Edwin Weru on 21/08/2025.
//

public enum RegistrationType {
    case individual
    case organization
}

public enum RegistrationOTPType: String {
    case sms = "SMS"
    case email = "EMAIL"
}

final class RegistrationBuilder {
    // Common
    var email: String?
    var phoneNumber: String?
    var password: String?
    var confirmPassword: String?
    var country: Int?
    var languagePreference: Int?
    var location: Int?
    var verificationMode: String?
    var role: Int?
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var gender: Int?
    var otpRequestId: String?
    var code: String?
    var referralCode: String?

    // Organization-only
    var organizationName: String?
    var organizationType: Int?
    var organizationSize: Int?
    var postalAddress: String?
    var physicalAddress: String?
    var website: String?

    func build(as type: RegistrationType) throws -> RegistrationRequest {
        switch type {
        case .individual:
            return try buildIndividual()
        case .organization:
            return try buildOrganization()
        }
    }

    private func buildIndividual() throws -> IndividualRegistrationRequest {
        guard
            let email,
            let phoneNumber,
            let password,
            let confirmPassword,
            let country,
            let languagePreference,
            let location,
            let verificationMode,
            let role,
            let firstName,
            let lastName,
            let gender,
            let otpRequestId,
            let code
        else { throw ValidationError.missingFields }

        return IndividualRegistrationRequest(
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            confirmPassword: confirmPassword,
            country: country,
            languagePreference: languagePreference,
            location: location,
            verificationMode: verificationMode,
            role: role,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            gender: gender,
            otpRequestId: otpRequestId,
            code: code,
            referralCode: referralCode
        )
    }

    private func buildOrganization() throws -> OrganizationRegistrationRequest {
        guard
            let email,
            let phoneNumber,
            let password,
            let confirmPassword,
            let country,
            let languagePreference,
            let location,
            let verificationMode,
            let role,
            let organizationName,
            let organizationType,
            let organizationSize,
            let postalAddress,
            let physicalAddress,
            let firstName,
            let lastName,
            let gender,
            let otpRequestId,
            let code
        else { throw ValidationError.missingFields }

        return OrganizationRegistrationRequest(
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            confirmPassword: confirmPassword,
            country: country,
            languagePreference: languagePreference,
            location: location,
            verificationMode: verificationMode,
            role: role,
            organizationName: organizationName,
            organizationType: organizationType,
            organizationSize: organizationSize,
            postalAddress: postalAddress,
            physicalAddress: physicalAddress,
            website: website,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            gender: gender,
            otpRequestId: otpRequestId,
            code: code,
            referralCode: referralCode
        )
    }
}

enum ValidationError: Error {
    case missingFields
}
