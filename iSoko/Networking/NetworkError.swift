//
//  NetworkError.swift
//  
//
//  Created by Edwin Weru on 21/08/2025.
//

import Foundation

// MARK: — Network Error
public enum NetworkError: Error {
    case server(BasicResponse)   // decoded API error
    case decoding(Error)         // failed to decode JSON
    case moya(Error)             // network / request error
    case underlying(Error)
    case statusCode(Int)
    case decodingFailed
    case custom(String)
}
