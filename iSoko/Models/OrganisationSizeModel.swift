//
//  OrganisationSizeModel.swift
//  
//
//  Created by Edwin Weru on 26/09/2025.
//

public struct OrganisationSizeModel: Decodable {
    let id: Int?
    let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    public init(with model: OrganisationSizeResponse) {
        self.id = model.id
        self.name = model.name
    }
    
}
