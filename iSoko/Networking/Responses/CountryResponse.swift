//
//  CountryResponse.swift
//  
//
//  Created by Edwin Weru on 17/04/2026.
//

// Country model
public struct CountryResponse: Codable {
    public let id: Int
    public let name: String?
    public let code: String?
    public let defaultLanguage: CommonIdNameResponse?
}

extension CountryResponse {
    init?(from pair: IDNamePairInt?) {
        guard let pair,
              let id = pair.id else {
            return nil
        }

        self.id = id
        self.name = pair.name
        self.code = nil
        self.defaultLanguage = nil
    }
}
