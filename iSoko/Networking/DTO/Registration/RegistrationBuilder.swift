//
//  RegistrationBuilder.swift
//  
//
//  Created by Edwin Weru on 21/08/2025.
//

final class RegistrationBuilder {

    // MARK: - Required user fields
    var userTypeId: Int = 1
    
    var email: String?
    var phoneNumber: String?
    var password: String?
    var confirmPassword: String?
    var location: IDNamePairString?
    var role: IDNamePairInt?
    var gender: IDNamePairInt?
    var ageGroup: IDNamePairInt?
    var firstName: String?
    var middleName: String?
    var lastName: String?
    
    // Optional
    var referralCode: String?
    var otpRequestId: String?
    var code: String?
    
    // MARK: - Build RegistrationRequest
    func build() throws -> RegistrationRequest {

        let missing = findMissingFields()
        if !missing.isEmpty {
            print("❌ Missing required fields: \(missing.joined(separator: ", "))")
            throw ValidationError.missingFields(missing)
        }

        // Fill defaults for optional fields required by API
        return RegistrationRequest(
            email: email ?? "",
            phoneNumber: phoneNumber ?? "",
            phoneNumberCountry: nil,
            password: password ?? "",
            confirmPassword: confirmPassword ?? password ?? "",
            languagePreference: 0,
            verificationMode: "email",
            country: IDNamePairInt(id: 0, name: ""),
            location: location!,
            role: role!,
            gender: gender!,
            ageGroup: ageGroup!,
            firstName: firstName ?? "",
            middleName: middleName ?? "",
            lastName: lastName ?? "",
            otpRequestId: otpRequestId ?? "",
            code: code ?? "",
            referralCode: referralCode,
            isOrganization: false,
            organizationName: nil,
            organizationType: nil,
            organizationSize: nil,
            postalAddress: nil,
            physicalAddress: nil,
            website: nil
        )
    }

    private func findMissingFields() -> [String] {
        var missing: [String] = []

        func check(_ field: Any?, name: String) {
            if field == nil { missing.append(name) }
        }

        check(email, name: "email")
        check(phoneNumber, name: "phoneNumber")
        check(password, name: "password")
        check(confirmPassword, name: "confirmPassword")
        check(location, name: "location")
        check(role, name: "role")
        check(ageGroup, name: "ageGroup")
        check(firstName, name: "firstName")
        check(lastName, name: "lastName")
        check(gender, name: "gender")

        return missing
    }
}
