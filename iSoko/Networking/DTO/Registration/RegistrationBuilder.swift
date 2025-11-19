//
//  RegistrationBuilder.swift
//  
//
//  Created by Edwin Weru on 21/08/2025.
//

final class RegistrationBuilder {

    // MARK: - Common fields
    var email: String?
    var phoneNumber: String?
    var password: String?
    var confirmPassword: String?
    var country: IDNamePairInt?
    var languagePreference: Int?
    var location: IDNamePairString?
    var verificationMode: String?
    var role: IDNamePairInt?
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var gender: IDNamePairInt?
    var otpRequestId: String?
    var code: String?
    var referralCode: String?

    // MARK: - Organization-only
    var organizationName: String?
    var organizationType: IDNamePairInt?
    var organizationSize: IDNamePairInt?
    var postalAddress: String?
    var physicalAddress: String?
    var website: String?

    // MARK: - Registration Type
    var isOrganization: Bool = false

    // MARK: - Build
//    func build() throws -> RegistrationRequest {
//        // Validate common required fields
//        guard
//            let email,
//            let phoneNumber,
//            let password,
//            let confirmPassword,
//            let country,
//            let location,
//            let verificationMode,
//            let role,
//            let firstName,
//            let lastName,
//            let gender,
//            let otpRequestId,
//            let code
//        else {
//            throw ValidationError.missingFields
//        }
//
//        // If organization, validate extra required fields
//        if isOrganization {
//            guard
//                let organizationName,
//                let organizationType,
//                let organizationSize,
//                let postalAddress,
//                let physicalAddress
//            else {
//                throw ValidationError.missingFields
//            }
//        }
//
//        return RegistrationRequest(
//            email: email,
//            phoneNumber: phoneNumber,
//            password: password,
//            confirmPassword: confirmPassword,
//            country: country,
//            languagePreference: languagePreference,
//            location: location,
//            verificationMode: verificationMode,
//            role: role,
//            firstName: firstName,
//            middleName: middleName,
//            lastName: lastName,
//            gender: gender,
//            otpRequestId: otpRequestId,
//            code: code,
//            referralCode: referralCode,
//            isOrganization: isOrganization,
//            organizationName: organizationName,
//            organizationType: organizationType,
//            organizationSize: organizationSize,
//            postalAddress: postalAddress,
//            physicalAddress: physicalAddress,
//            website: website
//        )
//    }
    
    func build() throws -> RegistrationRequest {

        let missing = findMissingFields()

        if !missing.isEmpty {
            print("❌ Missing required fields: \(missing.joined(separator: ", "))")
            throw ValidationError.missingFields(missing)
        }

        // Safe to unwrap now because we validated everything
        return RegistrationRequest(
            email: email!,
            phoneNumber: phoneNumber!,
            password: password!,
            confirmPassword: confirmPassword!,
            country: country!,
            languagePreference: languagePreference,
            location: location!,
            verificationMode: verificationMode!,
            role: role!,
            firstName: firstName!,
            middleName: middleName,
            lastName: lastName!,
            gender: gender!,
            otpRequestId: otpRequestId!,
            code: code!,
            referralCode: referralCode,
            isOrganization: isOrganization,
            organizationName: organizationName,
            organizationType: organizationType,
            organizationSize: organizationSize,
            postalAddress: postalAddress,
            physicalAddress: physicalAddress,
            website: website
        )
    }

    
    private func findMissingFields() -> [String] {
        var missing: [String] = []

        func check(_ field: Any?, name: String) {
            if field == nil { missing.append(name) }
        }

        // COMMON FIELDS
        check(email, name: "email")
        check(phoneNumber, name: "phoneNumber")
        check(password, name: "password")
        check(confirmPassword, name: "confirmPassword")
        check(country, name: "country")
        check(location, name: "location")
        check(verificationMode, name: "verificationMode")
        check(role, name: "role")
        check(firstName, name: "firstName")
        check(lastName, name: "lastName")
        check(gender, name: "gender")
        check(otpRequestId, name: "otpRequestId")
        check(code, name: "code")

        // ORG-ONLY
        if isOrganization {
            check(organizationName, name: "organizationName")
            check(organizationType, name: "organizationType")
            check(organizationSize, name: "organizationSize")
            check(postalAddress, name: "postalAddress")
            check(physicalAddress, name: "physicalAddress")
        }

        return missing
    }

}

extension RegistrationRequest {
    func toUserProfile(
        id: Int,
        username: String,
        profileImage: String? = nil,
        ageGroup: IDNamePairInt,
        status: String = "Active",
        verified: Bool = true,
        datetimeCreated: String
    ) -> UserProfile {
        return UserProfile(
            id: id,
            email: email,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            username: username,
            profileImage: profileImage,
            gender: gender,
            ageGroup: ageGroup,
            role: role,
            location: location,
            country: country,
            status: status,
            verified: verified,
            datetimeCreated: datetimeCreated
        )
    }
}

extension RegistrationRequest {
    func toOrganizationProfile(
        id: Int,
        username: String,
        status: String = "Active",
        verified: Bool = true,
        datetimeCreated: String
    ) -> OrganizationProfile {
        guard
            let organizationName,
            let organizationType,
            let organizationSize,
            let postalAddress,
            let physicalAddress
        else {
            fatalError("Missing organization fields")
        }

        return OrganizationProfile(
            id: id,
            email: email,
            organizationName: organizationName,
            organizationType: organizationType,
            organizationSize: organizationSize,
            postalAddress: postalAddress,
            physicalAddress: physicalAddress,
            website: website,
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            username: username,
            gender: gender,
            role: role,
            location: location,
            country: country,
            status: status,
            verified: verified,
            datetimeCreated: datetimeCreated
        )
    }
}
