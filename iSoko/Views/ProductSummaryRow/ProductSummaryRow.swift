//
//  ProductSummaryRow.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit

final class ProductSummaryRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: ProductSummaryCell.self)
    public var cellClass: AnyClass? { ProductSummaryCell.self }

    private let model: ProductSummaryModel

    public init(tag: Int, model: ProductSummaryModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? ProductSummaryCell else { return cell }
        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
