//
//  PromoCodeFormRow.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import DesignSystemKit
import UIKit

public final class PromoCodeFormRow: FormRow {

    public let tag: Int

    public let reuseIdentifier =
        String(describing: PromoCodeFormCell.self)

    public var cellClass: AnyClass? {
        PromoCodeFormCell.self
    }

    public let config: PromoCodeModel

    public init(
        tag: Int,
        config: PromoCodeModel
    ) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? PromoCodeFormCell else {
            assertionFailure("Expected PromoCodeFormCell")
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
