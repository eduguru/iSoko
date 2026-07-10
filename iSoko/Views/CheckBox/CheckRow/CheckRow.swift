//
//  CheckRow.swift
//  
//
//  Created by Edwin Weru on 10/07/2026.
//

import DesignSystemKit
import UIKit

public final class CheckRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: CheckRowCell.self)
    public var cellClass: AnyClass? { CheckRowCell.self }

    public var config: CheckRowConfig

    public init(tag: Int, config: CheckRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        guard let cell = cell as? CheckRowCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func validate() -> Bool {
        true
    }

    public func validateWithError() -> Bool {
        validate()
    }
}
