//
//  VendorTokenService.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

final class VendorTokenService {

    func refreshToken(refreshToken: String, completion: @escaping (Result<GuestTokenModel, Error>) -> Void) {
        // Vendor-specific refresh token API logic
        let params: [String: String] = [
            "grant_type": "refresh_token",
            "client_id": ApiEnvironment.clientId,
            "client_secret": ApiEnvironment.clientSecret,
            "refresh_token": refreshToken
        ]
        requestToken(params: params, completion: completion)
    }

    private func requestToken(params: [String: String], completion: @escaping (Result<GuestTokenModel, Error>) -> Void) {
        // Vendor API request logic here...
    }
}
