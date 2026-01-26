//
//  InfoCardRow.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit
import DesignSystemKit

public final class InfoCardRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: InfoCardCell.self)
    public var cellClass: AnyClass? { InfoCardCell.self }

    private let config: InfoCardCellConfig

    public init(tag: Int, config: InfoCardCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        guard let cell = cell as? InfoCardCell else { return cell }
        cell.configure(with: config)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
