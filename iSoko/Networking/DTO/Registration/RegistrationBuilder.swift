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
    var country: IDNamePairInt?
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

        // Provide default values for optional fields
        let safeMiddleName = middleName?.trimmingCharacters(in: .whitespacesAndNewlines)
        let middleNameValue = (safeMiddleName?.isEmpty ?? true) ? "null" : safeMiddleName!

        return RegistrationRequest(
            email: email ?? "N/A",
            phoneNumber: phoneNumber ?? "N/A",
            phoneNumberCountry: nil,
            password: password ?? "12345678",
            confirmPassword: confirmPassword ?? password ?? "12345678",
            languagePreference: 0,
            verificationMode: "email",
            country: country ?? IDNamePairInt(id: 0, name: "N/A"),
            location: location ?? IDNamePairString(id: "0", name: "N/A"),
            role: role ?? IDNamePairInt(id: 0, name: "N/A"),
            gender: gender ?? IDNamePairInt(id: 0, name: "N/A"),
            ageGroup: ageGroup ?? IDNamePairInt(id: 0, name: "N/A"),
            firstName: firstName ?? "N/A",
            middleName: middleNameValue,
            lastName: lastName ?? "N/A",
            otpRequestId: otpRequestId ?? "N/A",
            code: code ?? "N/A",
            referralCode: referralCode ?? "N/A",
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
        check(country, name: "country") // <-- now required

        return missing
    }
}

extension RegistrationRequest {
    func mapToCreateUserRequest() -> [String: Any] {
        return [
            "email": email ?? "",
            "phoneNumber": phoneNumber ?? "",
            "password": password ?? "",
            "firstName": firstName ?? "",
            "middleName": middleName ?? "null",
            "lastName": lastName ?? "",
            "countryId": country.id ?? 0,
            "locationId": location.id ?? 0,
            "roleId": role.id ?? 0,
            "genderId": gender.id ?? 0,
            "ageGroupId": ageGroup.id ?? 0
        ]
    }
}
