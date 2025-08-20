//
//  MultiButtonFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class MultiButtonFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: MultiButtonFormCell.self)
    public var cellClass: AnyClass? { MultiButtonFormCell.self }

    public let model: MultiButtonFormModel

    public init(tag: Int, model: MultiButtonFormModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? MultiButtonFormCell else {
            assertionFailure("Expected MultiButtonFormCell")
            return cell
        }

        cell.configure(with: model)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
