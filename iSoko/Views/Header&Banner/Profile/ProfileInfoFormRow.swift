//
//  ProfileInfoFormRow.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import DesignSystemKit
import UIKit

public final class ProfileInfoRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: ProfileInfoCell.self)
    public var cellClass: AnyClass? { ProfileInfoCell.self }

    public let config: ProfileInfoCellConfig

    public init(tag: Int, config: ProfileInfoCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? ProfileInfoCell else {
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
