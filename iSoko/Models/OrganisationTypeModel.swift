
//
//  OrganisationTypeModel.swift
//
//
//  Created by Edwin Weru on 26/09/2025.
//



public struct OrganisationTypeModel: Decodable {
    let id: Int?
    let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    public init(with model: OrganisationTypeResponse) {
        self.id = model.id
        self.name = model.name
    }
    
}

extension OrganisationTypeModel {
    var toIDNamePairInt: IDNamePairInt {
        IDNamePairInt(id: self.id ?? 0, name: self.name ?? "")
    }
}

