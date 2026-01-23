//
//  OrderSummaryRow.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit
import DesignSystemKit

// MARK: - OrderSummaryCellConfig & Item Struct

public struct OrderItem {
    public let quantity: Int
    public let name: String
    public let amount: String
    
    public init(quantity: Int, name: String, amount: String) {
        self.quantity = quantity
        self.name = name
        self.amount = amount
    }
}


// MARK: - FormRow integration

public final class OrderSummaryRow: FormRow {
    public let tag: Int
    public let reuseIdentifier = String(describing: OrderSummaryCell.self)
    public var cellClass: AnyClass? { OrderSummaryCell.self }
    
    public let config: OrderSummaryCellConfig
    
    public init(tag: Int, config: OrderSummaryCellConfig) {
        self.tag = tag
        self.config = config
    }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? OrderSummaryCell else {
            assertionFailure("Expected OrderSummaryCell")
            return cell
        }
        cell.configure(with: config)
        return cell
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
