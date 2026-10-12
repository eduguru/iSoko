//
//  AssociationMemberResponse.swift
//  
//
//  Created by Edwin Weru on 03/02/2026.
//

public struct AssociationMemberResponse: Codable {
    public let id: Int
    public let user: Contact?
    public let association: IDNamePairInt?
    public let reviewer: Contact?
    public let reviewComent: String?
    public let status: ReviewStatus?
}

/// The API returns membership `status` as a plain string in some responses
/// (AssociationMembershipView) and as `{ "status": "..." }` in others (AssociationMember).
/// Accept both so a successful join/cancel is never reported as a decoding failure.
public struct ReviewStatus: Codable {
    public let status: String?
    
    private enum CodingKeys: String, CodingKey { case status }
    
    public init(status: String?) { self.status = status }
    
    public init(from decoder: Decoder) throws {
        if let single = try? decoder.singleValueContainer(), let text = try? single.decode(String.self) {
            self.status = text
            return
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
