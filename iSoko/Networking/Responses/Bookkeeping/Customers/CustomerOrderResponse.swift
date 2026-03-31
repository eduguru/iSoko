//
//  CustomerOrderResponse.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

// MARK: - Order Response

import Foundation
import UIKit

public struct CustomerOrderResponse: Codable {
    public let id: Int
    public let orderNumber: String
    public let amount: Double
    public let status: String
    public let datetimeCreated: String
    public let buyer: CustomerUser
    public let seller: CustomerUser
    public let products: [CustomerProductResponse]?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber
        case amount
        case status
        case datetimeCreated
        case buyer
        case seller
        case products
    }
}

// MARK: - Computed Helpers

public extension CustomerOrderResponse {

    // MARK: Title
    var displayTitle: String {
        "Order #\(orderNumber)"
    }

    // MARK: Subtitle (items count OR fallback)
    var displaySubtitle: String? {
        let count = products?.count ?? 0
        guard count > 0 else { return nil }
        return "\(count) item\(count == 1 ? "" : "s")"
    }

    // MARK: Buyer full name
    var buyerFullName: String {
        "\(buyer.firstName ?? "") \(buyer.lastName ?? "")"
            .trimmingCharacters(in: .whitespaces)
    }

    // MARK: Seller full name
    var sellerFullName: String {
        "\(seller.firstName ?? "") \(seller.lastName ?? "")"
            .trimmingCharacters(in: .whitespaces)
    }

    // MARK: Formatted Amount
    func formattedAmount(currency: String = "Ksh") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        let value = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(currency) \(value)"
    }

    // MARK: Status formatting
    var displayStatus: String {
        status.capitalized
    }

    var statusColor: UIColor {
        switch status.lowercased() {
        case "pending":
            return .systemOrange
        case "completed", "delivered":
            return .systemGreen
        case "cancelled":
            return .systemRed
        case "failed":
            return .systemRed
        default:
            return .systemBlue
        }
    }

    // MARK: Date formatting
    var formattedDate: String {
        guard let date = isoDate else { return datetimeCreated }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return formatter.string(from: date)
    }

    var formattedDateTime: String {
        guard let date = isoDate else { return datetimeCreated }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }

    private var isoDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: datetimeCreated)
    }

    // MARK: Total quantity (useful for UI)
    var totalQuantity: Int {
        products?.reduce(0) { $0 + ($1.quantity ?? 0) } ?? 0
    }
}



// MARK: - User (buyer/seller)

public struct CustomerUser: Codable {
    public let id: Int
    public let email: String?
    public let firstName: String?
    public let lastName: String?
}
