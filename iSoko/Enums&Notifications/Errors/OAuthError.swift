//
//  OAuthError.swift
//  
//
//  Created by Edwin Weru on 02/02/2026.
//

enum OAuthError: Error {
    case invalidAuthURL
    case missingAuthorizationCode
    case emptyResponse
    case missingRefreshToken
    case invalidRedirect
    case unauthorized(reason: String?)
    case httpStatus(code: Int, message: String?)
}
