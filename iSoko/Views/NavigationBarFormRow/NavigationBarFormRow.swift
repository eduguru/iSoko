//
//  NavigationBarFormRow.swift
//  
//
//  Created by Edwin Weru on 13/11/2025.
//

import DesignSystemKit
import UIKit

public final class NavigationBarFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: NavigationBarFormCell.self)
    public var cellClass: AnyClass? { NavigationBarFormCell.self }
    
    // The configuration model for the navigation bar
    public var navBarConfig: NavigationBarConfig
    
    public init(tag: Int, navBarConfig: NavigationBarConfig) {
        self.tag = tag
        self.navBarConfig = navBarConfig
    }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let navBarCell = cell as? NavigationBarFormCell else { return cell }
        
        // Configure the navigation bar cell with the configuration model
        navBarCell.configure(with: navBarConfig)
        
        return cell
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 60 // Adjust height for your navigation bar cell
    }
}
