//
//  TraderVerificationDocResponse.swift
//  
//
//  Created by Edwin Weru on 26/08/2025.
//

public struct TraderVerificationDocResponse: Decodable {
    let id: Int
    let name: String?
    let codeName: String?
    let requireInput: Bool?
    let inputType: String?
    let inputLength: Int?
    let requiresSubmission: Bool?
}
