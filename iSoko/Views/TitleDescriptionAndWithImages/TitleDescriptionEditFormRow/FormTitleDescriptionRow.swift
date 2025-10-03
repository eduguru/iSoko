//
//  FormTitleDescriptionRow.swift
//  
//
//  Created by Edwin Weru on 02/10/2025.
//

import UIKit
import DesignSystemKit

public final class FormTitleDescriptionRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: FormTitleDescriptionRowCell.self)
    public var cellClass: AnyClass? { FormTitleDescriptionRowCell.self }

    public let config: FormTitleDescriptionRowConfig

    public init(tag: Int, config: FormTitleDescriptionRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? FormTitleDescriptionRowCell else {
            assertionFailure("Expected FormTitleDescriptionRowCell")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
