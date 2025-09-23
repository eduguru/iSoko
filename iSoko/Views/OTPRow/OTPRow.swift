//
//  OTPRow.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit
import DesignSystemKit

// MARK: - Row

public final class OTPRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: OTPRowCell.self)
    public var cellClass: AnyClass? { OTPRowCell.self }

    public var config: OTPRowConfig

    public init(tag: Int, config: OTPRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? OTPRowCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
