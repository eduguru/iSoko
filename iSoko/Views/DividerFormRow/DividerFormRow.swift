//
//  DividerFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class DividerFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: DividerFormCell.self)
    public var cellClass: AnyClass? { DividerFormCell.self }

    public init(tag: Int) {
        self.tag = tag
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        20
    }
}
