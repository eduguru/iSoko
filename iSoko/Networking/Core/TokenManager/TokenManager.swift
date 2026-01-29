//
//  TokenManager.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

final class TokenManager {
    private var tokens: [TokenType: AuthToken] = [:]

    func getToken(type: TokenType) -> AuthToken? {
        return tokens[type]
    }

    func saveToken(token: AuthToken) {
        tokens[token.authTokenType ?? .guest] = token
    }

    func refreshToken(type: TokenType, refreshToken: String, completion: @escaping (Result<AuthToken, Error>) -> Void) {
        switch type {
        case .guest:
            // Call the API to refresh guest token
            OAuthTokenService().refreshToken(refreshToken: refreshToken) { result in
                switch result {
                case .success(let newToken):
                    let guestToken = GuestToken(
                        refreshToken: newToken.refreshToken,
                        accessToken: newToken.accessToken,
                        expiresIn: newToken.expiresIn
                    )
                    self.saveToken(token: guestToken)
                    completion(.success(guestToken))

                case .failure(let error):
                    completion(.failure(error))
                }
            }

        case .loggedIn:
            // Call the API to refresh logged-in user token
            OAuthTokenService().refreshToken(refreshToken: refreshToken) { result in
                switch result {
                case .success(let newToken):
                    let loggedInToken = OAuthLoggedInToken(
                        refreshToken: newToken.refreshToken,
                        accessToken: newToken.accessToken,
                        expiresIn: newToken.expiresIn
                    )
                    self.saveToken(token: loggedInToken)
                    completion(.success(loggedInToken))

                case .failure(let error):
                    completion(.failure(error))
                }
            }

        case .vendor:
            // Call the API to refresh vendor token
            VendorTokenService().refreshToken(refreshToken: refreshToken) { result in
                switch result {
                case .success(let newToken):
                    let vendorToken = VendorToken(
                        refreshToken: newToken.refreshToken,
                        accessToken: newToken.accessToken,
                        expiresIn: newToken.expiresIn
                    )
                    self.saveToken(token: vendorToken)
                    completion(.success(vendorToken))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    // Method to check if any token is still valid
    func isAnyTokenValid() -> Bool {
        return tokens.values.contains { $0.isValid() }
    }
}
