//
//  TermsCheckboxRow.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit
import DesignSystemKit

public final class TermsCheckboxRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: TermsCheckboxRowCell.self)
    public var cellClass: AnyClass? { TermsCheckboxRowCell.self }

    public var config: TermsCheckboxRowConfig

    public init(tag: Int, config: TermsCheckboxRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? TermsCheckboxRowCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func validate() -> Bool {
        return config.isAgreed
    }

    public func validateWithError() -> Bool {
        // Optional: visually highlight error on the cell if needed
        return validate()
    }
}
