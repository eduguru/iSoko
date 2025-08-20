//
//  AuthToken.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation

public protocol AuthToken: Codable {
    var accessToken: String { get }
    var refreshToken: String? { get }
    var expiresIn: Int { get }
}
