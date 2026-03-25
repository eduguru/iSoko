//
//  CustomerReportResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct CustomerReportResponse: Codable {
    public let customers: Int?
    public let newCustomers: Int?
    public let history: [CustomerHistoryResponse]?
}
