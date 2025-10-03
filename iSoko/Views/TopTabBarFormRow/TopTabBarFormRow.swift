//
//  TopTabBarFormRow.swift
//  
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit

public struct TopTabBarFormRow: FormRow {
    public let tabs: [String]
    public var selectedIndex: Int
    public var tag: Int
    public var onTabSelected: ((Int) -> Void)?

    public var reuseIdentifier: String {
        return "TopTabBarCell"
    }

    public var cellClass: AnyClass? {
        return TopTabBarCell.self
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? TopTabBarCell else { return cell }
        cell.configure(with: tabs, selectedIndex: selectedIndex)
        cell.onTabSelected = { index in
            onTabSelected?(index)
        }
        return cell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 56 // or UITableView.automaticDimension
    }
}

//let topTabRow = TopTabBarFormRow(
//    tabs: ["Overview", "Orders", "Reviews"],
//    selectedIndex: 0,
//    tag: 9000,
//    onTabSelected: { index in
//        print("Switched to tab \(index)")
//        // Update state, reload rows, etc.
//    }
//)
