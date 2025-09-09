//
//  CertificateApi.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import Moya
import Foundation
import NetworkingKit

public struct CertificateApi {
    public static func getToken(grant_type: String, client_id: String, client_secret: String) -> ValueResponseTarget<TokenModel> {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters = [
            "grant_type": grant_type,
            "client_id": client_id,
            "client_secret": client_secret
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

    public static func getRefreshToken(grant_type: String, client_id: String, client_secret: String, refresh_token: String) -> ValueResponseTarget<TokenModel> {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters = [
            "grant_type": grant_type,
            "client_id": client_id,
            "client_secret": client_secret,
            "refresh_token": refresh_token
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
