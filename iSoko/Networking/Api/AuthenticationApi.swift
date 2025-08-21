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
}
