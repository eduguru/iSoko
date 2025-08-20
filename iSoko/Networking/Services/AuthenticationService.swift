//
//  AuthenticationService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import NetworkingKit
import Combine

public protocol AuthenticationService {
    
    func login(phoneNumber: String, otp: String) -> String?
    
    func preValidateEmail() -> String?
    func preValidatePhone() -> String?
    
    func requestOTP(phoneNumber: String) -> String?
    func validateOTP(phoneNumber: String, otp: String) -> String?
    
    func initiatePasswordReset(phoneNumber: String) -> String?
    func resetPassword(phoneNumber: String, newPassword: String) -> String?
    
    func registerIndividual(phoneNumber: String, otp: String, password: String) -> String?
    func registerOrganization(phoneNumber: String, otp: String, password: String) -> String?
    
    func updateUserPassword(_ password: String)
}

public final class AuthenticationServiceImp: AuthenticationService {
    
    public func preValidateEmail() -> String? {
        return nil
    }
    
    public func preValidatePhone() -> String? {
        return nil
    }
    
    public func requestOTP(phoneNumber: String) -> String? {
        return nil
    }
    
    public func validateOTP(phoneNumber: String, otp: String) -> String? {
        return nil
    }
    
    public func login(phoneNumber: String, otp: String) -> String? {
        return nil
    }
    
    public func initiatePasswordReset(phoneNumber: String) -> String? {
        return nil
    }
    
    public func resetPassword(phoneNumber: String, newPassword: String) -> String? {
        return nil
    }
    
    public func registerIndividual(phoneNumber: String, otp: String, password: String) -> String? {
        return nil
    }
    
    public func registerOrganization(phoneNumber: String, otp: String, password: String) -> String? {
        return nil
    }
    
    public func updateUserPassword(_ password: String) {
        
    }
}
