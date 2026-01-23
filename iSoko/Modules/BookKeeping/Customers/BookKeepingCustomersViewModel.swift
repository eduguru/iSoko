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
            id: Tags.Section.filter.rawValue,
            cells: [filterRow]
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
    private lazy var  filterRow: FormRow = makeFilterRowRow()
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private func makeFilterRowRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Finacial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .white,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: { [weak self] in
                self?.goToDetails?()
            }
        )
        
        let row = TitleDropDownFilterFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Spending",
                titleIcon: UIImage(systemName: "chart.bar"),
                subtitle: "This month",
                status: CardStatusStyle(
                    text: "On track",
                    textColor: .systemGreen,
                    backgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "checkmark")
                )
            ),
            right: DualCardItemConfig(
                title: "Bills",
                titleIcon: UIImage(systemName: "doc.text"),
                subtitle: "2 due soon",
                status: CardStatusStyle(
                    text: "Action needed",
                    textColor: .systemOrange,
                    backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "exclamationmark.triangle")
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
                title: "Transaction \(index + 1)",
                subtitle: hasActions ? "Requires action" : "No actions available",
                amount: "$\(Int.random(in: 10...250)).00",
                amountColor: .label,
                status: hasActions ? "Pending" : "Completed",
                statusColor: hasActions ? .systemOrange : .systemGreen,
                primaryAction: hasActions
                    ? ActionCardConfig(
                        title: "Pay",
                        icon: UIImage(systemName: "creditcard"),
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
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
        }
        enum Cells: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            
        }
    }
}
