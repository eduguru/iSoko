//
//  FiltersFormRow.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import DesignSystemKit
import UIKit

public final class FiltersFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: FiltersCell.self)
    public var cellClass: AnyClass? { FiltersCell.self }

    private let config: FiltersCellConfig

    public init(tag: Int, config: FiltersCellConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? FiltersCell else {
            assertionFailure("Expected FiltersCell")
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

//
// 1️⃣ Card With Title + (2 inline) + (1 below)
//┌──────────────────────────────┐
// │ Type                        │
// │ Sale Type   | Time Period   │
// │ Region                      │
// └──────────────────────────────┘
//
//let row1 = FiltersFormRow(
//    tag: 1,
//    config: FiltersCellConfig(
//        title: "Type",
//        rows: [
//            [
//                FilterFieldConfig(
//                    placeholder: "Sale Type",
//                    iconSystemName: "tag",
//                    onTap: { print("Sale Type tapped") }
//                ),
//                FilterFieldConfig(
//                    placeholder: "Time Period",
//                    iconSystemName: "calendar",
//                    onTap: { print("Time Period tapped") }
//                )
//            ],
//            [
//                FilterFieldConfig(
//                    placeholder: "Region",
//                    iconSystemName: "mappin.and.ellipse",
//                    onTap: { print("Region tapped") }
//                )
//            ]
//        ]
//    )
//)
//
// 2️⃣ Card With Title + (2 inline) + (2 inline)
//┌──────────────────────────────┐
// │ Type                        │
// │ Sale Type   | Time Period   │
// │ Org Type    | Start Period  │
// └──────────────────────────────┘
//
//let row2 = FiltersFormRow(
//    tag: 2,
//    config: FiltersCellConfig(
//        title: "Type",
//        rows: [
//            [
//                FilterFieldConfig(
//                    placeholder: "Sale Type",
//                    iconSystemName: "tag",
//                    onTap: { print("Sale Type tapped") }
//                ),
//                FilterFieldConfig(
//                    placeholder: "Time Period",
//                    iconSystemName: "calendar",
//                    onTap: { print("Time Period tapped") }
//                )
//            ],
//            [
//                FilterFieldConfig(
//                    placeholder: "Org Type",
//                    iconSystemName: "building.2",
//                    onTap: { print("Org Type tapped") }
//                ),
//                FilterFieldConfig(
//                    placeholder: "Start Period",
//                    iconSystemName: "calendar.badge.clock",
//                    onTap: { print("Start Period tapped") }
//                )
//            ]
//        ]
//    )
//)
//
// 3️⃣ No Title + Two Inline Rows
//┌──────────────────────────────┐
// │ Sale Type   | Time Period   │
// │ Org Type    | Start Period  │
// └──────────────────────────────┘
//
//
//Simply omit title:
//
//let row3 = FiltersFormRow(
//    tag: 3,
//    config: FiltersCellConfig(
//        rows: [
//            [
//                FilterFieldConfig(
//                    placeholder: "Sale Type",
//                    iconSystemName: "tag",
//                    onTap: { print("Sale Type tapped") }
//                ),
//                FilterFieldConfig(
//                    placeholder: "Time Period",
//                    iconSystemName: "calendar",
//                    onTap: { print("Time Period tapped") }
//                )
//            ],
//            [
//                FilterFieldConfig(
//                    placeholder: "Org Type",
//                    iconSystemName: "building.2",
//                    onTap: { print("Org Type tapped") }
//                ),
//                FilterFieldConfig(
//                    placeholder: "Start Period",
//                    iconSystemName: "calendar.badge.clock",
//                    onTap: { print("Start Period tapped") }
//                )
//            ]
//        ]
//    )
//)
//
//
//Because:
//
//titleLabel.isHidden = config.title == nil
//
//
//the title row collapses automatically.
