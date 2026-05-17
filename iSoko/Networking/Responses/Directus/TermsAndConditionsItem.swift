//
//  TermsAndConditionsItem.swift
//  
//
//  Created by Edwin Weru on 14/05/2026.
//

// MARK: - Terms & Conditions
struct TermsAndConditionsItem: Decodable {
    let id: Int
    let createdOn: String?
    let modifiedOn: String?
    let content: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case content = "Content"
    }
}
