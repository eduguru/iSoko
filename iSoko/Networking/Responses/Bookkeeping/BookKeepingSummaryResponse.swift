
//
//  BookKeepingSummaryResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct BookKeepingSummaryResponse: Codable {
    public let totalRevenue: Double?
    public let totalExpenses: Double?
    public let totalProducts: Int?
    public let lowStock: Int?
    public let recentActivity: [BookKeepingRecentActivityResponse]?
}

public struct BookKeepingRecentActivityResponse: Codable {
    public let module: String?
    public let item: String?
    public let value: Double?
    public let datetimeCreated: String?
}
