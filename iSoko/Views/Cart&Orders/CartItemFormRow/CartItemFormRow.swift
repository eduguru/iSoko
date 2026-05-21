//
//  CartItemFormRow.swift
//  
//
//  Created by Edwin Weru on 04/03/2026.
//

import UIKit
import DesignSystemKit

final class CartItemFormRow: FormRow {

    let tag: Int
    let reuseIdentifier = CartItemCell.reuseIdentifier
    let cellClass: AnyClass? = CartItemCell.self

    private let viewModel: CartItemViewModel

    init(tag: Int, viewModel: CartItemViewModel) {
        self.tag = tag
        self.viewModel = viewModel
    }

    func configure(_ cell: UITableViewCell,
                   indexPath: IndexPath,
                   sender: FormViewController?) -> UITableViewCell {

        guard let cell = cell as? CartItemCell else { return cell }
        cell.configure(with: viewModel)
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        150
    }
}
