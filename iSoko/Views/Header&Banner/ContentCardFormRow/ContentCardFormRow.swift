//
//  ContentCardFormRow.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import DesignSystemKit
import UIKit

public final class ContentCardFormRow: FormRow {

    public let tag: Int

    public let reuseIdentifier =
        String(describing: ContentCardFormCell.self)

    public var cellClass: AnyClass? {
        ContentCardFormCell.self
    }

    public let config: ContentCardModel

    public init(
        tag: Int,
        config: ContentCardModel
    ) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? ContentCardFormCell else {
            assertionFailure("Expected ContentCardFormCell")
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
