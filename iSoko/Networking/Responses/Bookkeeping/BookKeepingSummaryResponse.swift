
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
    public let action: String?
    public let entityType: String?
    public let entityId: Int?
    public let summary: String?
    public let datetimeCreated: String?
    public let value: String?
    public let metadata: String?
}
