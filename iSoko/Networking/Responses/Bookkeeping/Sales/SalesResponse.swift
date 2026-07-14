//
//  SalesResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

import Foundation

public struct SalesResponse: Codable {
    public let id: Int

    public let type: IDNamePairInt?
    public let customer: IDNamePairInt?

    public let totalAmount: Double?
    public let paid: Double?
    public let balance: Double?

    public let paymentMethod: IDNamePairInt?
    public let saleDate: Date?

    public let description: String?
    public let items: [SalesItemResponse]?

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case customer

        case totalAmount = "amount"
        case paid
        case balance

        case paymentMethod
        case description
        case items

        case date
        case datetimeCreated
        case saleDateAlt = "sale_date"
    }

    // MARK: - Decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        type = try container.decodeIfPresent(IDNamePairInt.self, forKey: .type)
        customer = try container.decodeIfPresent(IDNamePairInt.self, forKey: .customer)

        totalAmount = try container.decodeIfPresent(Double.self, forKey: .totalAmount)
        paid = try container.decodeIfPresent(Double.self, forKey: .paid)
        balance = try container.decodeIfPresent(Double.self, forKey: .balance)

        paymentMethod = try container.decodeIfPresent(IDNamePairInt.self, forKey: .paymentMethod)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        items = try container.decodeIfPresent([SalesItemResponse].self, forKey: .items)

        let dateString =
            try container.decodeIfPresent(String.self, forKey: .datetimeCreated)
            ?? container.decodeIfPresent(String.self, forKey: .saleDateAlt)
            ?? container.decodeIfPresent(String.self, forKey: .date)

        if let dateString {
            let isoFormatter = ISO8601DateFormatter()

            if let date = isoFormatter.date(from: dateString) {
                saleDate = date
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                saleDate = formatter.date(from: dateString)
            }
        } else {
            saleDate = nil
        }
    }

    // MARK: - Encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(customer, forKey: .customer)

        try container.encodeIfPresent(totalAmount, forKey: .totalAmount)
        try container.encodeIfPresent(paid, forKey: .paid)
        try container.encodeIfPresent(balance, forKey: .balance)

        try container.encodeIfPresent(paymentMethod, forKey: .paymentMethod)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(items, forKey: .items)

        if let saleDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")

            try container.encode(formatter.string(from: saleDate), forKey: .date)
        }
    }
}

public struct SalesItemResponse: Codable {
    public let id: Int
    public let product: IDNamePairInt?
    public let quantity: Double?
    public let unitPrice: Double?
    public let totalPrice: Double?
}
