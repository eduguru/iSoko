//
//  OrderConfirmItemFormRow.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import DesignSystemKit
import UIKit

final class OrderConfirmItemFormRow: FormRow {

    let tag: Int
    let reuseIdentifier = OrderConfirmItemCell.reuseIdentifier
    let cellClass: AnyClass? = OrderConfirmItemCell.self

    private let viewModel: OrderConfirmItemViewModel

    init(tag: Int, viewModel: OrderConfirmItemViewModel) {
        self.tag = tag
        self.viewModel = viewModel
    }

    func configure(_ cell: UITableViewCell,
                   indexPath: IndexPath,
                   sender: FormViewController?) -> UITableViewCell {

        guard let cell = cell as? OrderConfirmItemCell else { return cell }
        cell.configure(with: viewModel)
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension // 150
    }
}
