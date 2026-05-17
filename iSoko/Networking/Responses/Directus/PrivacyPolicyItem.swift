//
//  PrivacyPolicyItem.swift
//  
//
//  Created by Edwin Weru on 14/05/2026.
//

// MARK: - Privacy Policy (Optional)
struct PrivacyPolicyItem: Decodable {
    let id: Int
    let content: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case content = "Content"
    }
}
