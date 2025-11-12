//
//  CarouselRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public struct CarouselRow: FormRow {
    public var tag: Int
    public var model: CarouselModel?

    public init(tag: Int, model: CarouselModel? = nil) {
        self.tag = tag
        self.model = model
    }

    public var reuseIdentifier: String { "CarouselCell" }
    public var rowType: FormRowType { .tableView }
    public var cellTag: String { String(tag) }
    public var nibName: String? { nil }
    public var cellClass: AnyClass? { CarouselCell.self }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let carouselCell = cell as? CarouselCell, let model = model else { return cell }
        carouselCell.configure(with: model)
        return carouselCell
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        guard let model = model else { return 180 }
        switch model.paginationPlacement {
        case .below: return 160
        case .inside: return 140
        }
    }
}
