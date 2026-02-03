//
//  GuestTokenApiError.swift
//  
//
//  Created by Edwin Weru on 02/02/2026.
//

public enum GuestTokenApiError: Error {
    case unauthorized(reason: String?)
    case httpStatus(code: Int, message: String)
    case decoding(Error)
    case transport(Error)
    case unknown
}
