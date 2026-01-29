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
    ) -> ValueResponseTarget<GuestTokenResponse> {
        let parameters: [String: String] = [
            "grant_type": AppConstants.GrantType.authorizationCode.rawValue,
            "client_id": OAuthConfig.clientId,
            "code": code,
            "redirect_uri": OAuthConfig.redirectURI,
            "code_verifier": codeVerifier
        ]
        
        return requestToken(params: parameters)
    }
    
    public static func refreshToken(refreshToken: String) -> ValueResponseTarget<GuestTokenResponse> {
        let parameters: [String: String] = [
            "grant_type": AppConstants.GrantType.refreshToken.rawValue,
            "client_id": OAuthConfig.clientId,
            "refresh_token": refreshToken,
            "scope": OAuthConfig.scope
        ]
        
        return requestToken(params: parameters)
    }
    
    
    
    public static func requestToken(params: [String: String]) -> ValueResponseTarget<GuestTokenResponse> {
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters = params
        
        let baseURL = URL(string: OAuthConfig.tokenEndpoint)!
        
        let t = AnyTarget(
            baseURL: baseURL,
            path: "",
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
