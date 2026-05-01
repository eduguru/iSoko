//
//  SmartInfoCardFormRow.swift
//  
//
//  Created by Edwin Weru on 01/05/2026.
//

import DesignSystemKit
import UIKit

public final class SmartInfoCardFormRow: FormRow {
    
    public let tag: Int
    public let reuseIdentifier = String(describing: SmartInfoCardCell.self)
    public var cellClass: AnyClass? { SmartInfoCardCell.self }
    
    public let config: SmartCardConfig
    
    public init(tag: Int, config: SmartCardConfig) {
        self.tag = tag
        self.config = config
    }
    
    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        
        guard let cell = cell as? SmartInfoCardCell else {
            return cell
        }
        
        cell.configure(with: config)
        return cell
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
