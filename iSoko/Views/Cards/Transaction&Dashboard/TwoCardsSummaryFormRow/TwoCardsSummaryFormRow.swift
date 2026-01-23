//
//  TwoCardsSummaryFormRow.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit

public final class TwoCardsSummaryFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: TwoStatusCardsViewCell.self)
    public var cellClass: AnyClass? { TwoStatusCardsViewCell.self }

    public var model: TwoCardsSummaryViewModel

    public init(tag: Int, model: TwoCardsSummaryViewModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? TwoStatusCardsViewCell else {
            return cell
        }

        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
