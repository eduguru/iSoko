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
import UIKit

public struct AuthenticationApi {
    
    public static func login(
        grant_type: String,
        client_id: String,
        client_secret: String,
        username: String,
        password: String
    ) -> ValueResponseTarget<TokenResponse> {
        
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
}


//MARK: - validation
public extension AuthenticationApi {
    
    static func userAvailabilityCheck(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<AnyCodable> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "users/availability",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: target)
    }
    
    //MARK: - pre validation
    public static func preValidateEmail(email: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let apiBaseURL: URL = { URL(string: "https://tz.isoko.africa/wit-backend/" )! }()
        
        let t = AnyTarget(
            baseURL: apiBaseURL,
            path: "api/user/pre-validation/email",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            requiresAuth: false,
            authorizationType: .none
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func preValidatePhoneNumber(phoneNumber: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber
        ]
        
        let apiBaseURL: URL = { URL(string: "https://tz.isoko.africa/wit-backend/" )! }()
        
        let t = AnyTarget(
            baseURL: apiBaseURL,
            path: "api/user/pre-validation/phone",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            requiresAuth: false,
            authorizationType: .none
        )
        
        return BasicResponseTarget(target: t)
    }
    
    static func accountVerificationOTP(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<AnyCodable> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "otp",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: t)
    }
    
    static func verifyAccountOTP(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<AnyCodable> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "contact-methods/verification",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: t)
    }
    
}

//MARK: - Registration
public extension AuthenticationApi {
    //MARK: - pre validation
    static func register(_ request: RegistrationRequest, accessToken: String) -> ValueResponseTarget<UserRegistrationResponse> {
        let userDict: [String: Any] = request.mapToCreateUserRequest().asDictionary
        let userJSON = try? JSONSerialization.data(withJSONObject: userDict)

//        let imageFile = profileImage.flatMap {
//            UploadFile(
//                data: $0.jpegData(compressionQuality: 0.8)!,
//                name: "profileImage",
//                fileName: "profile.jpg",
//                mimeType: "image/jpeg"
//            )
//        }
//        
//        let files = imageFile.map { [$0] } ?? []

        let t = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/users",
            jsonPartName: "user",
            jsonData: userJSON,
            files: [],
            requiresAuth: false
        )

        return ValueResponseTarget(target: t.asAnyTarget())
    }

//MARK: - Password Reset
    static func initiatePasswordReset( value: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [:]
        
        var path: String = "api/password/request/reset"
        
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
}

// MARK: - Authentication API
extension AuthenticationApi {
    
    static func passwordResetInitiate(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<AnyCodable> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "auth/password-reset/request",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: target)
    }
    
    static func passwordResetComplete(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<AnyCodable> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "auth/password-reset/confirm",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: target)
    }
       
}
