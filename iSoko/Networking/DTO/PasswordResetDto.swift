//
//  PasswordResetDto.swift
//  
//
//  Created by Edwin Weru on 21/08/2025.
//

public enum PasswordResetType: String, Codable {
    case phoneNumber = "phoneNumber"
    case email = "email"
}

public struct PasswordResetDto: Codable {
    let userId: Int
    let phoneNumber: String
    let code: String
    let password: String
    let confirmPassword: String
    
    public init(
        userId: Int,
        phoneNumber: String,
        code: String,
        password: String,
        confirmPassword: String
    ) {
        self.userId = userId
        self.phoneNumber = phoneNumber
        self.code = code
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
    var dictionary: [String: Any] {
        var dict: [String: Any] = [:]
        
        do {
            let dict = try self.toDictionary()
            print(dict)
        } catch {
            print("❌ Conversion failed:", error)
        }
        
        return dict
    }
}
