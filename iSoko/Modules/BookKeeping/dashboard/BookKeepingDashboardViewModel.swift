//
//  BookKeepingDashboardViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BookKeepingDashboardViewModel: FormViewModel {
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
            makeQuickActionsSection(),
            makeBusinessMetricsSection(),
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
    
    private func makeQuickActionsSection() -> FormSection {
        FormSection(
            id: Tags.Section.quickActions.rawValue,
            cells: [quickActionsRow, quickActionsNoTitleRow]
        )
    }
    
    private func makeBusinessMetricsSection() -> FormSection {
        FormSection(
            id: Tags.Section.businessMetrics.rawValue,
            cells: [businessMetricsRow]
        )
    }
    
    private func makeRecentActivitiesSection() -> FormSection {
        FormSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: makeRecentActivitiesRow()
        )
    }
    
    // MARK: - Update Sections -

    // MARK: - Lazy Rows
    private lazy var  filterRow: FormRow = makeFilterRowRow()
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private lazy var  quickActionsRow: FormRow = makeQuickActionsRow()
    private lazy var  quickActionsNoTitleRow: FormRow = makeQuickNoTitleActionsRow()
    
    private lazy var  businessMetricsRow: FormRow = makeBusinessMetricsRow()
    // private lazy var  recentActivitiesRow: FormRow = makeRecentActivitiesRow()
    
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
    
    private func makeQuickActionsRow() -> FormRow {
        let payBill = StatusCardViewModel(
            title: "Record Sale",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemGreen,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56
        )
        
        let transfer = StatusCardViewModel(
            title: "Add Expense",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemRed,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80
        )

        let row = TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                title: "Quick Actions",
                description: "Common bookeeping tasks",
                cards: TwoStatusCardsViewModel(
                    first: payBill,
                    second: transfer,
                    layout: .horizontal
                )
            )
        )
        return row
    }
    
    private func makeQuickNoTitleActionsRow() -> FormRow {

            let quickAction1 = StatusCardViewModel(
                title: "Manage Stock",
                image: UIImage(systemName: "bolt.fill"),
                backgroundColor: .systemBlue,
                iconTintColor: .white,
                textColor: .white,
                iconSize: CGSize(width: 28, height: 28),
                fixedHeight: 56
            )
            
            let quickAction2 = StatusCardViewModel(
                title: "View Reports",
                image: UIImage(systemName: "bolt.fill"),
                backgroundColor: .systemPurple,
                iconTintColor: .white,
                textColor: .white,
                iconSize: CGSize(width: 28, height: 28),
                fixedHeight: 80
            )
            
            let row = TwoStatusCardsFormRow(
                tag: 101,
                model: TwoStatusCardsViewModel(
                    first: quickAction1,
                    second: quickAction2,
                    layout: .horizontal
                )
            )
            
            return row
    }
    
    private func makeBusinessMetricsRow() -> FormRow {
        let payBill = StatusCardViewModel(
            title: "Customers",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .purple,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56
        )
        
        let transfer = StatusCardViewModel(
            title: "Suppliers",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemTeal,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80
        )

        let row = TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                title: "Business Management",
                description: "Manage customers and suppliers",
                cards: TwoStatusCardsViewModel(
                    first: payBill,
                    second: transfer,
                    layout: .horizontal
                )
            )
        )
        return row
    }
    
    private func makeRecentActivitiesRow() -> [FormRow] {
        let sampleTransactions = [
            Transaction(title: "Salary", description: "January Salary", amount: "$5000", isIncome: true, icon: UIImage(systemName: "dollarsign.circle")),
            Transaction(title: "Rent", description: "Monthly rent", amount: "$1200", isIncome: false, icon: UIImage(systemName: "house")),
            Transaction(title: "Groceries", description: nil, amount: "$320", isIncome: false, icon: UIImage(systemName: "cart"))
        ]

        let rows = makeTransactionRows(sampleTransactions)
        
        return rows
    }
    
    // Lazy factory that creates rows
    
    func makeTransactionRows(_ transactions: [Transaction]) -> [FormRow] {
        transactions.enumerated().map { index, tx in
            TransactionRow(
                tag: index,
                config: TransactionCellConfig(
                    image: tx.icon,
                    imageSize: .init(width: 36, height: 36),
                    imageStyle: .init(
                        shape: .circle,
                        backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                        inset: 6
                    ),
                    title: tx.title,
                    description: tx.description,
                    amount: tx.amount,
                    amountColor: tx.isIncome ? .systemGreen : .systemRed,
                    spacing: 12,
                    contentInsets: .init(top: 12, left: 16, bottom: 12, right: 16),
                    onTap: {
                        
                    },
                    isCardStyleEnabled: true,
                    cardCornerRadius: 12,
                    cardBackgroundColor: .systemBackground,
                    cardBorderColor: .systemGray4,
                    cardBorderWidth: 1
                )
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


struct Transaction {
    let title: String
    let description: String?
    let amount: String
    let isIncome: Bool
    let icon: UIImage?
}
