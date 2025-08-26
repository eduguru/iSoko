//
//  OrganisationDetailsRequestDto.swift
//  
//
//  Created by Edwin Weru on 26/08/2025.
//

public struct OrganisationDetailsRequestDto: Codable {
    let organizationName: String
    let organizationType: String
    let organizationSize: String
    
    public init(
        organizationName: String,
        organizationType: String,
        organizationSize: String
    )
    {
        self.organizationName = organizationName
        self.organizationType = organizationType
        self.organizationSize = organizationSize
    }
}
