//
//  StockImageResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct StockImageResponse: Codable {
    public let id: Int?
    public let url: String?
    public let primary: Bool?
    public let approved: Bool?
    public let active: Bool?
}
