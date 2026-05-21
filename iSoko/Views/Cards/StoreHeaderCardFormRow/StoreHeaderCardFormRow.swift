//
//  StoreHeaderCardFormRow.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import DesignSystemKit
import UIKit

// MARK: - Row

public final class StoreHeaderCardFormRow: FormRow {

    public let tag: Int

    public let reuseIdentifier: String =
        String(describing: StoreHeaderCardCell.self)

    public var cellClass: AnyClass? {
        StoreHeaderCardCell.self
    }

    public let config: StoreHeaderCardConfig

    public init(
        tag: Int,
        config: StoreHeaderCardConfig
    ) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? StoreHeaderCardCell else {
            return cell
        }

        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(
        for indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}
