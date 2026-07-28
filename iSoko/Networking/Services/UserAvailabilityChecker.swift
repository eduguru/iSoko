//
//  UserAvailabilityChecker.swift
//  
//
//  Created by Edwin Weru on 28/07/2026.
//

// MARK: - UserAvailabilityService

enum UserAvailabilityContact {
    case email(String)
    case phone(String)

    var parameters: [String: Any] {
        switch self {
        case .email(let value):   return ["email": value]
        case .phone(let value):   return ["phoneNumber": value]
        }
    }

    var errorMessage: String {
        switch self {
        case .email: return "Email already exists."
        case .phone: return "Phone already exists."
        }
    }
}

enum UserAvailabilityError: Error {
    case alreadyExists(String)
    case unexpectedResponse
    case network(Error)
}

final class UserAvailabilityChecker {

    private let authService = NetworkEnvironment.shared.authenticationService

    /// Returns true if contact is available (does NOT exist yet), throws otherwise.
    func check(_ contact: UserAvailabilityContact, guestToken: String) async throws -> Bool {
        do {
            let response = try await authService.userAvailabilityCheck(
                parameters: contact.parameters,
                accessToken: guestToken
            )

            guard let dict = response.asDictionary,
                  let available = dict["available"]?.asBool
            else {
                throw UserAvailabilityError.unexpectedResponse
            }

            if available {
                // "available: true" means it already exists on this API
                throw UserAvailabilityError.alreadyExists(contact.errorMessage)
            }

            return true

        } catch let error as UserAvailabilityError {
            throw error
        } catch {
            throw UserAvailabilityError.network(error)
        }
    }
}
