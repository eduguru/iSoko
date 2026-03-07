//
//  BookKeepingReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingReportsViewModel: FormViewModel {
    var gotoConfirm: (() -> Void)?

    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    selectionInputRow,
                    SpacerFormRow(tag: 20),
                    timeFrameRow,
                    filterFormRow
                ]
            )
        ]
    }

    // MARK: - Rows
    private lazy var selectionInputRow = makeSelectionGrid()
    private lazy var timeFrameRow = makeTimeFrameGrid()
    private lazy var filterFormRow: FormRow = makeFilterFormRow()
    
    private func makeSelectionGrid() -> FormRow {
        
        SelectableCardGridRow(
            tag: 1,
            config: .init(
                items: [
                    .init(title: "Sales", subtitle: "Track revenue", icon: UIImage(systemName:"chart.line.uptrend.xyaxis"), onTap: {_ in }),
                    .init(title: "Expenses", subtitle: "Monitor spending", icon: UIImage(systemName:"calendar")),
                    .init(title: "Stock", subtitle: "Inventory levels", icon: UIImage(systemName:"archivebox")),
                    .init(title: "Profit & Loss", subtitle: "Financial performance", icon: UIImage(systemName:"chart.bar")),
                    .init(title: "Customers", subtitle: "Top buyers", icon: UIImage(systemName:"person.2")),
                    .init(title: "Suppliers", subtitle: "Vendors", icon: UIImage(systemName:"truck.box"))
                ],
                allowsMultipleSelection: false
            )
        )
    }
    
    private func makeTimeFrameGrid() -> FormRow {
        // MARK: - Define your options
        let timeframeOptions = [
            TimeframeOption(title: "Today"),
            TimeframeOption(title: "Yesterday"),
            TimeframeOption(title: "Last 7 Days"),
            TimeframeOption(title: "Last 30 Days"),
            TimeframeOption(title: "This Month"),
            TimeframeOption(title: "Custom") // This will trigger custom callback
        ]

        // MARK: - Create the config
        let timeframeConfig = TimeframeSelectorConfig(
            options: timeframeOptions,
            allowsMultipleSelection: false,
            selectedIndex: 0
        )

        // MARK: - Create the FormRow
        let timeframeRow = TimeframeSelectorRow(
            tag: 101,
            config: timeframeConfig
        )

        // MARK: - Assign callbacks
        timeframeRow.onSelectionChanged = { selectedIndex in
            print("Selected timeframe index: \(selectedIndex)")
            print("Selected timeframe title: \(timeframeOptions[selectedIndex].title)")
        }

        timeframeRow.onCustomSelected = {
            print("Custom timeframe tapped! Show date picker or custom view here.")
        }
        
        return timeframeRow
    }
    
    private func makeFilterFormRow() -> FormRow {
        let row = FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "",
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Start Date",
                            selectedValue: nil,
                            iconSystemName: "calendar",
                            onTap: {
                                print("Start tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "End Date",
                            selectedValue: nil,
                            iconSystemName: "calendar",
                            onTap: {
                                print("End tapped")
                            }
                        )
                    ]
                ],
                message: ""
            )
        )

        return row
    }

    // MARK: - handle selections
    

    // MARK: - Reload
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Submit
    private func submit() async {

    }

    // MARK: - State
    private struct State {
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    private enum SectionTag: Int {
        case main = 0
        case timeFrame = 1
    }

    private enum CellTag: Int {
        case category = 4
        case continueButton = 9
    }
}


