//
//  StoreProfileCardRow.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit

public final class StoreProfileCardRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: StoreProfileCardCell.self)
    public var cellClass: AnyClass? { StoreProfileCardCell.self }

    public let config: StoreProfileCardConfig

    public init(tag: Int, config: StoreProfileCardConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell,
                          indexPath: IndexPath,
                          sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? StoreProfileCardCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
