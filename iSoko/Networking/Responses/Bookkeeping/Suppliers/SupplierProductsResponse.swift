//
//  SupplierProductsResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

import UIKit

public struct SupplierProductResponse: Codable {
    public let id: Int
    public let name: String?
    public let orderTotal: Double?
    public let date: String?
    public let currentStock: Int?
    public let stockLevel: StockLevel?
}

public enum StockLevel: String, Codable {
    case good = "GOOD"
    case low = "LOW"
    case critical = "CRITICAL"
}

// MARK: - UI Helpers
public extension StockLevel {
    
    var title: String {
        switch self {
        case .good: return "Good"
        case .low: return "Low"
        case .critical: return "Critical"
        }
    }
    
    var iconName: String {
        switch self {
        case .good: return "checkmark.circle.fill"
        case .low: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .good: return .systemGreen
        case .low: return .systemOrange
        case .critical: return .systemRed
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .good: return UIColor.systemGreen.withAlphaComponent(0.1)
        case .low: return UIColor.systemOrange.withAlphaComponent(0.1)
        case .critical: return UIColor.systemRed.withAlphaComponent(0.1)
        }
    }
}
