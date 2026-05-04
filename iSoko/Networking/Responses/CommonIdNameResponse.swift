//
//  CommonIdNameResponse.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

public struct CommonIdNameResponse: Codable {
    public let id: Int
    public let name: String
    public let description: String?
    public let active: Bool?
}

extension CommonIdNameModel {
    init(from response: CommonIdNameResponse) {
        self.id = response.id
        self.name = response.name
        self.description = response.description
    }
}
