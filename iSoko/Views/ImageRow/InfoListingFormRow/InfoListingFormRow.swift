//
//  InfoListingFormRow.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import DesignSystemKit
import UIKit

public final class InfoListingFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: InfoListingViewCell.self)
    public var cellClass: AnyClass? { InfoListingViewCell.self }
    
    public let rowType: FormRowType = .tableView
    
    // The configuration model
    public var model: InfoListingModel
    
    public init(tag: Int, model: InfoListingModel) {
        self.tag = tag
        self.model = model
    }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let customCell = cell as? InfoListingViewCell else { return cell }
        
        // Configure the cell with the configuration model
        customCell.configure(with: model)
        
        return cell
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 150 //UITableView.automaticDimension
    }
}
