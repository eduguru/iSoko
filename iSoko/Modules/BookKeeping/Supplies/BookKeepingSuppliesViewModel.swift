//
//  BookKeepingSuppliesViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BookKeepingSuppliesViewModel: FormViewModel {
   var goToDetails: (() -> Void)? = { }
    
    private var state = State()

    override init() {
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections -
    private func makeSections() -> [FormSection] {
        [
            makeFilterSection(),
            makeFinancialSummarySection(),
            makeRecentActivitiesSection()
        ]
    }

    private func makeFilterSection() -> FormSection {
        FormSection(
            id: Tags.Section.search.rawValue,
            cells: [searchRow]
        )
    }
    
    private func makeFinancialSummarySection() -> FormSection {
        FormSection(
            id: Tags.Section.financialSummary.rawValue,
            cells: [financialSummaryRow]
        )
    }
    
    private func makeRecentActivitiesSection() -> FormSection {
        FormSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: makeTransactionActionRows()
        )
    }
    
    // MARK: - Update Sections -

    // MARK: - Lazy Rows
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private lazy var searchRow = makeSearchRow()
    
    private func makeSearchRow() -> FormRow {
        SearchFormRow(
            tag: Tags.Cells.search.rawValue,
            model: SearchFormModel(
                placeholder: "Search",
                keyboardType: .default,
                searchIcon: UIImage(systemName: "magnifyingglass"),
                searchIconPlacement: .right,
                filterIcon: nil,
                didTapSearchIcon: { print("🔍 Search tapped") },
                didTapFilterIcon: { print("⚙️ Filter tapped") }
            )
        )
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Suppliers",
                titleIcon: nil,
                subtitle: "36",
                status: CardStatusStyle(
                    text: "24% since last week",
                    textColor: .systemGreen,
                    backgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                    icon: .stockmarketArrowUp
                )
            ),
            right: DualCardItemConfig(
                title: "Active Suppliers",
                titleIcon: nil,
                subtitle: "2",
                status: CardStatusStyle(
                    text: "24% since last week",
                    textColor: .systemOrange,
                    backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                    icon: .stockmarketArrowDown
                )
            )
        )

        let row = DualCardFormRow(
            tag: 100,
            config: config
        )

        return row
    }
    
    // Lazy factory that creates rows
    func makeTransactionActionRows() -> [FormRow] {
        (0..<10).map { index in

            let hasActions = index.isMultiple(of: 2)

            let config = TransactionActionsCellConfig(
                title: "ABC Company \(index + 1)",
                subtitle:  "0712345678",
                amount: "$\(Int.random(in: 10...250)).00",
                amountColor: .label,
                status: "3 items supplied ",
                statusColor: .darkGray,
                primaryAction: hasActions
                    ? ActionCardConfig(
                        title: "View Details",
                        icon: UIImage(systemName: "eye"),
                        backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                        textColor: .systemBlue,
                        onTap: {
                            print("Pay tapped on row \(index)")
                        }
                    )
                    : nil,
                secondaryAction: hasActions
                    ? InlineActionConfig(
                        title: "Edit",
                        icon: UIImage(systemName: "pencil"),
                        onTap: {
                            print("Edit tapped on row \(index)")
                        }
                    )
                    : nil
            )

            return TransactionActionsRow(
                tag: index,
                config: config
            )
        }
    }

    // MARK: - State
    private struct State {
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case search = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
        }
        enum Cells: Int {
            case search = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            
        }
    }
}

