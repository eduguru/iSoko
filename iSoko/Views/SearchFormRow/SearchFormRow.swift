//
//  SearchFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class SearchFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: SearchFormCell.self)
    public var cellClass: AnyClass? { SearchFormCell.self }

    public var model: SearchFormModel

    public init(tag: Int, model: SearchFormModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? SearchFormCell else {
            assertionFailure("Expected SearchFormCell")
            return cell
        }

        cell.configure(with: model)
        return cell
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        56
    }
}
