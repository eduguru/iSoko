//
//  CommonIdNameModel.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

public struct CommonIdNameModel: Decodable {
    public let id: Int
    public let name: String
    public let description: String?

    public init(id: Int, name: String, description: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
    }

    public init(with model: CommonIdNameResponse) {
        self.id = model.id
        self.name = model.name
        self.description = model.description
    }
}
