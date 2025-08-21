//
//  AuthenticationApi.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//
import Moya
import Foundation

public struct AuthenticationApi {
    
    public static func login(
        grant_type: String,
        client_id: String,
        client_secret: String,
        username: String,
        password: String
    ) -> ValueResponseTarget<TokenModel> {
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters = [
            "grant_type": grant_type,
            "client_id": client_id,
            "client_secret": client_secret,
            "username": username,
            "password": password
        ]
        
        let t = AnyTarget(
            path: "oauth/token",
            method: .post,
            task: .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.httpBody
            ),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: t)
    }
    
    public static func preValidateEmail(email: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let t = AnyTarget(
            path: "api/user/pre-validation/email",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func preValidatePhoneNumber(phoneNumber: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber
        ]
        
        let t = AnyTarget(
            path: "api/user/pre-validation/phone",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func accountVerificationOTP(type: String, contact: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "type": type,
            "contact": contact,
            "autoDetectionHash": "defaultSmsHashXYZ"
        ]
        
        let t = AnyTarget(
            path: "account-verification/pre-registration",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
}

//MARK: - New Registration
public extension AuthenticationApi {
    /// Register an individual user
    public static func registerIndividual(request: IndividualRegistrationRequest, accessToken: String ) -> BasicResponseTarget {
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let t = AnyTarget(
            path: "api/user/register/individual", // 👈 adjust if backend uses same path as org
            method: .post,
            task: .requestJSONEncodable(request),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    /// Register an organization
    public static func registerOrganization(request: OrganizationRegistrationRequest, accessToken: String) -> BasicResponseTarget {
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let t = AnyTarget(
            path: "api/user/register/organization", // 👈 adjust if backend uses same path
            method: .post,
            task: .requestJSONEncodable(request),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
}



//MARK: - Password Reset
public extension AuthenticationApi {
    
}
