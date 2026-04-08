//
//  SpacerFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class SpacerFormRow: FormRow {
    public let tag: Int
    public let height: CGFloat
    public let reuseIdentifier: String = String(describing: SpacerFormCell.self)
    public var cellClass: AnyClass? { SpacerFormCell.self }

    public init(tag: Int, height: CGFloat = 8) {
        self.tag = tag
        self.height = height
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return height
    }
}
