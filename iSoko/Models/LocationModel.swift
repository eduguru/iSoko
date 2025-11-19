//
//  LocationModel.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

public struct LocationModel: Decodable {
    let id: Int?
    let name: String?
    let codeName: String?
    
    public init(id: Int? = nil, name: String? = nil, codeName: String? = nil) {
        self.id = id
        self.name = name
        self.codeName = codeName
    }
    
    public init(with model: LocationResponse) {
        self.id = model.id
        self.name = model.name
        self.codeName = model.codeName
    }
}

extension LocationModel {
    var toIDNamePairInt: IDNamePairInt {
        IDNamePairInt(id: self.id ?? 0, name: self.name ?? "")
    }
    
    var toIDNamePairString: IDNamePairString {
        IDNamePairString(id: "\(self.id ?? 0)", name: self.name ?? "")
    }
}
