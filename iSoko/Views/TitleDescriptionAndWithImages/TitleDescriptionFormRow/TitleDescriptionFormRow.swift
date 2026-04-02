//
//  TitleDescriptionFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class TitleDescriptionFormRow: FormRow {
    
    public let tag: Int
    public let reuseIdentifier: String = String(describing: TitleDescriptionFormCell.self)
    public var cellClass: AnyClass? { TitleDescriptionFormCell.self }
    
    public let rowType: FormRowType = .tableView
    
    public var model: TitleDescriptionModel
    
    public init(tag: Int, model: TitleDescriptionModel) {
        self.tag = tag
        self.model = model
    }
    
    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        
        guard let cell = cell as? TitleDescriptionFormCell else {
            assertionFailure("Expected TitleDescriptionFormCell")
            return cell
        }
        
        cell.configure(with: model)
        return cell
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}

public extension TitleDescriptionFormRow {
    convenience init(
        tag: Int,
        title: String,
        description: String
    ) {
        let model = TitleDescriptionModel(
            title: title,
            description: description
        )
        self.init(tag: tag, model: model)
    }
}
