//
//  BookKeepingPurchasesViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BookKeepingPurchasesViewModel: FormViewModel {
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
            cells: makeOrderSummaryRows()
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
    func makeOrderSummaryRows() -> [FormRow] {
        (0..<10).map { index in
            // For demo, every odd index is "Cash" status, even is "Paid"
            let isCash = index.isMultiple(of: 2)
            
            let items = [
                OrderItem(quantity: 2, name: "Bananas", amount: "Ksh 1,500"),
                OrderItem(quantity: 3, name: "Pastries", amount: "Ksh 2,000")
            ]
            
            let config = OrderSummaryCellConfig(
                orderTitle: "Order #\(2945 + index)",
                amount: "Ksh. \(3500 + index * 100)",
                dateString: "Oct \(27 + index), 2025",
                itemCountString: "\(items.count) items",
                statusText: isCash ? "Cash" : "Paid",
                statusTextColor: isCash
                ? UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                : UIColor.systemBlue, statusBackgroundColor: isCash
                ? UIColor(red: 0.85, green: 1, blue: 0.85, alpha: 1)
                : UIColor(red: 0.85, green: 0.9, blue: 1, alpha: 1), items: items
            )
            
            return OrderSummaryRow(tag: index, config: config)
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

