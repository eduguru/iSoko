//
//  EditableImageIdentityHeaderRow.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import DesignSystemKit
import UIKit

public final class EditableImageIdentityHeaderRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: EditableImageIdentityHeaderCell.self)
    public var cellClass: AnyClass? { EditableImageIdentityHeaderCell.self }

    public var config: EditableImageIdentityHeaderConfig

    public init(tag: Int, config: EditableImageIdentityHeaderConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell,
                          indexPath: IndexPath,
                          sender: FormViewController?) -> UITableViewCell {

        guard let cell = cell as? EditableImageIdentityHeaderCell else {
            assertionFailure("Wrong cell type")
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
