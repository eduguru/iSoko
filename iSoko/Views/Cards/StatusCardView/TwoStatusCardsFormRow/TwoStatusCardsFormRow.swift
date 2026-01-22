//
//  TwoStatusCardsFormRow.swift
//  
//
//  Created by Edwin Weru on 22/01/2026.
//

import DesignSystemKit
import UIKit

public final class TwoStatusCardsFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: TwoStatusCardsViewCell.self)
    public var cellClass: AnyClass? { TwoStatusCardsViewCell.self }

    public var model: TwoStatusCardsViewModel

    public init(tag: Int, model: TwoStatusCardsViewModel) {
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

        // If vertical → dynamic height
        if model.layout == .vertical {
            return UITableView.automaticDimension
        }

        // Horizontal → derive height from cards (or fallback)
        let heights = [
            model.first?.fixedHeight,
            model.second?.fixedHeight
        ].compactMap { $0 }

        return heights.max() ?? 72
    }
}
