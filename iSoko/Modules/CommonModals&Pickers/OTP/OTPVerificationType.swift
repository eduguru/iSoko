//
//  OTPVerificationType.swift
//  
//
//  Created by Edwin Weru on 26/09/2025.
//

public enum OTPVerificationType {
    case phone(number: String, title: String?)
    case email(address: String, title: String?)
    case authenticator(title: String?)
    case custom(target: String, title: String?)
    
    public var displayTitle: String {
        switch self {
        case .phone(_, let title),
             .email(_, let title),
             .authenticator(let title),
             .custom(_, let title):
            return title ?? defaultTitle
        }
    }

    public var targetValue: String {
        switch self {
        case .phone(let number, _):
            return number
        case .email(let address, _):
            return address
        case .authenticator:
            return "Authenticator"
        case .custom(let target, _):
            return target
        }
    }

    private var defaultTitle: String {
        switch self {
        case .phone:
            return "Verify your phone"
        case .email:
            return "Verify your email"
        case .authenticator:
            return "Enter your code"
        case .custom:
            return "Verify"
        }
    }
}

//let type1: OTPVerificationType = .phone(number: "+254700000000", title: "Enter the OTP sent to your phone")
//let type2: OTPVerificationType = .email(address: "user@example.com", title: nil)
//
//print(type1.displayTitle) // "Enter the OTP sent to your phone"
//print(type2.displayTitle) // "Verify your email"
//print(type2.targetValue)  // "user@example.com"
