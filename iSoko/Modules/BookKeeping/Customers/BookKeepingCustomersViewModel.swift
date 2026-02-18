//
//  BookKeepingCustomersViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BookKeepingCustomersViewModel: FormViewModel {
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
                title: "Total Customers",
                titleIcon: nil,
                subtitle: "140",
                status: CardStatusStyle(
                    text: "24% since last week",
                    textColor: .systemGreen,
                    backgroundColor: .app(.hex("#F0FFE5")),
                    icon: .stockmarketArrowUp
                )
            ),
            right: DualCardItemConfig(
                title: "Active Buyers",
                titleIcon: nil,
                subtitle: "23",
                status: CardStatusStyle(
                    text: "13% since last week",
                    textColor: .systemOrange,
                    backgroundColor: .app(.hex("#FFE5E6")),
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
                title: "Customer \(index + 1)",
                subtitle: "070480011\(index + 1)",
                amount: "$\(Int.random(in: 10...250)).00",
                amountColor: .label,
                status: hasActions ? "4 Purchases" : "10 Purchases",
                statusColor: .app(.hex("#717171")),
                primaryAction: hasActions
                    ? ActionCardConfig(
                        title: "View History",
                        icon: UIImage(systemName: "creditcard"),
                        backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                        textColor: .app(.hex("#656C7A")),
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
