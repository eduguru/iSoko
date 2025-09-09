//
//  AuthenticationApi.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//
import Moya
import Foundation
import UtilsKit
import NetworkingKit

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
            baseURL: ApiEnvironment.baseURL,
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
    
    //MARK: - pre validation
    public static func preValidateEmail(email: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
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
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/pre-validation/phone",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func accountVerificationOTP(type: RegistrationOTPType, contact: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "type": type.rawValue,
            "contact": contact,
            "autoDetectionHash": "defaultSmsHashXYZ"
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
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
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/register/individual",
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
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/register/organization",
            method: .post,
            task: .requestJSONEncodable(request),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }

//MARK: - Password Reset
    public static func initiatePasswordReset(type: PasswordResetType, value: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "\(type.rawValue)": value
        ]
        
        var path: String {
           switch type {
                case .email:
               return "api/password/request/email"
           case .phoneNumber:
               return "api/password/request/reset"
           @unknown default:
               fatalError()
            }
        }
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: path,
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }

    public static func passwordReset(type: PasswordResetType, dto: PasswordResetDto, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = dto.asDictionary
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/password/reset",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
}
