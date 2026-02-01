//
//  LoginOAuthTokenApi.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

import Moya
import Foundation
import NetworkingKit

public struct LoginOAuthTokenApi {
    public static func exchangeAuthorizationCode(
        code: String,
        codeVerifier: String
    ) -> ValueResponseTarget<TokenResponse> {
        // Add the "scope" parameter if required by the server
        let parameters: [String: String] = [
            "grant_type": AppConstants.GrantType.authorizationCode.rawValue,
            "client_id": OAuthConfig.clientId,
            "code": code,
            "redirect_uri": OAuthConfig.redirectURI,
            "code_verifier": codeVerifier,
            "scope": "openid"  // Add scope if needed (or replace with the correct scope)
        ]
        
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",  // Correct content type
            "Accept": "application/json"  // Expect JSON response
        ]
        
        let baseURL = URL(string: "https://api.dev.isoko.africa/v1/")!
        
        // Here we are making the request with URL encoding in the body
        let target = AnyTarget(
            baseURL: baseURL,
            path: "oauth2/token",
            method: .post,
            task: .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.httpBody // Ensures parameters are URL-encoded in the body
            ),
            headers: headers,
            authorizationType: .none // No auth header needed here
        )

        return ValueResponseTarget(target: target)
    }
    
    public static func refreshToken(refreshToken: String) -> ValueResponseTarget<TokenResponse> {
        let parameters: [String: String] = [
            "grant_type": AppConstants.GrantType.refreshToken.rawValue,
            "client_id": OAuthConfig.clientId,
            "refresh_token": refreshToken,
            "scope": OAuthConfig.scope  // Ensure the scope is included for refresh token
        ]
        
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",  // Correct content type
            "Accept": "application/json"  // Expect JSON response
        ]
        
        let baseURL = URL(string: "https://api.dev.isoko.africa/v1/")!
        
        // Here we are making the request with URL encoding in the body
        let target = AnyTarget(
            baseURL: baseURL,
            path: "oauth2/token",
            method: .post,
            task: .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.httpBody // Ensures parameters are URL-encoded in the body
            ),
            headers: headers,
            authorizationType: .none // No auth header needed here
        )

        return ValueResponseTarget(target: target)
    }
    
    public static func requestToken(params: [String: String]) -> ValueResponseTarget<TokenResponse> {
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",  // Correct content type
            "Accept": "application/json"  // Expect JSON response
        ]
        
        let baseURL = URL(string: "https://api.dev.isoko.africa/v1/")!
        
        // Here we are making the request with URL encoding in the body
        let target = AnyTarget(
            baseURL: baseURL,
            path: "oauth2/token",
            method: .post,
            task: .requestParameters(
                parameters: params,
                encoding: URLEncoding.httpBody // Ensures parameters are URL-encoded in the body
            ),
            headers: headers,
            authorizationType: .none // No auth header needed here
        )

        return ValueResponseTarget(target: target)
    }
}
