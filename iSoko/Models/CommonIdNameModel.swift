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

extension CommonIdNameModel {
    var toIDNamePairInt: IDNamePairInt {
        IDNamePairInt(id: self.id, name: self.name)
    }
}

extension CommonIdNameModel {
    init?(from pair: IDNamePairInt?) {
        guard let id = pair?.id,
              let name = pair?.name else {
            return nil
        }

        self.id = id
        self.name = name
        self.description = nil
    }
}

extension CommonIdNameModel {
    init?(from trader: TraderResponse) {
        guard let id = trader.id else { return nil }

        let name = [trader.firstName, trader.lastName]
            .compactMap { $0 }
            .joined(separator: " ")

        guard !name.isEmpty else { return nil }

        self.id = id
        self.name = name
        self.description = trader.email
    }
}
