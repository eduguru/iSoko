//
//  OrderBreakdownFormRow.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import UIKit
import DesignSystemKit

final class OrderBreakdownFormRow: FormRow {

    let tag: Int
    let reuseIdentifier = OrderBreakdownCell.reuseIdentifier
    let cellClass: AnyClass? = OrderBreakdownCell.self

    private let model: OrderBreakdownModel

    init(tag: Int, model: OrderBreakdownModel) {
        self.tag = tag
        self.model = model
    }

    func configure(_ cell: UITableViewCell,
                   indexPath: IndexPath,
                   sender: FormViewController?) -> UITableViewCell {

        guard let cell = cell as? OrderBreakdownCell else { return cell }
        cell.configure(with: model)
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
