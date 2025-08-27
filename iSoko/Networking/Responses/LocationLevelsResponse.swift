//
//  LocationLevelsResponse.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

public struct LocationLevelsResponse: Decodable {
    let id: Int?
    let name: String?
    let parentId: Int?
    let isActive: Bool?
    let addedBy: Int?
    let dateAdded: Int64?
}
