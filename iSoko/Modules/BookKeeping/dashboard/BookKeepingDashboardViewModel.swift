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
    var goToFilter: (() -> Void)? = { }
    
    var goToTotalSales: (() -> Void)? = { }
    var goToTotalProducts: (() -> Void)? = { }
    var goToTotalExpense: (() -> Void)? = { }
    var goToLowStock: (() -> Void)? = { }
    
    var goToRecordSales: (() -> Void)? = { }
    var goToAddExpense: (() -> Void)? = { }
    
    var goToManageStock: (() -> Void)? = { }
    var goToViewReports: (() -> Void)? = { }
    
    var goToCustomers: (() -> Void)? = { }
    var goToSuppliers: (() -> Void)? = { }
    
    private var state = State()
    
    override init() {
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - Financial Card Data
    
    private struct FinancialCardData {
        let title: String
        let icon: String
        let subtitle: String
        let statusText: String
        let statusColor: UIColor
        let statusIcon: String
        let backgroundColor: UIColor
        let action: (() -> Void)?
    }
    
    private lazy var financialCards: [FinancialCardData] = [
        FinancialCardData(
            title: "Total Sales",
            icon: "chart.bar",
            subtitle: "This month",
            statusText: "On track",
            statusColor: .systemGreen,
            statusIcon: "checkmark",
            backgroundColor: .app(.hex("#ECFDF5")),
            action: { [weak self] in self?.goToTotalSales?() }
        ),
        FinancialCardData(
            title: "Total Expenses",
            icon: "doc.text",
            subtitle: "2 due soon",
            statusText: "Action needed",
            statusColor: .systemOrange,
            statusIcon: "exclamationmark.triangle",
            backgroundColor: .app(.hex("#FEF2F2")),
            action: { [weak self] in self?.goToTotalExpense?() }
        ),
        FinancialCardData(
            title: "Total Products",
            icon: "chart.bar",
            subtitle: "This month",
            statusText: "On track",
            statusColor: .systemGreen,
            statusIcon: "checkmark",
            backgroundColor: .app(.hex("#EFF6FF")),
            action: { [weak self] in self?.goToTotalProducts?() }
        ),
        FinancialCardData(
            title: "Low Stock",
            icon: "doc.text",
            subtitle: "2 due soon",
            statusText: "Action needed",
            statusColor: .systemOrange,
            statusIcon: "exclamationmark.triangle",
            backgroundColor: .app(.hex("#FFF7ED")),
            action: { [weak self] in self?.goToLowStock?() }
        )
    ]
    
    private func makeFinancialItem(_ data: FinancialCardData) -> DualCardItemConfig {
        DualCardItemConfig(
            title: data.title,
            titleIcon: UIImage(systemName: data.icon),
            subtitle: data.subtitle,
            status: CardStatusStyle(
                text: data.statusText,
                textColor: data.statusColor,
                backgroundColor: data.statusColor.withAlphaComponent(0.15),
                icon: UIImage(systemName: data.statusIcon)
            ),
            backgroundColor: data.backgroundColor,
            onTap: data.action
        )
    }
    
    private func makeFinancialRow(_ left: FinancialCardData,
                                  _ right: FinancialCardData,
                                  tag: Int) -> FormRow {
        DualCardFormRow(
            tag: tag,
            config: DualCardCellConfig(
                left: makeFinancialItem(left),
                right: makeFinancialItem(right)
            )
        )
    }
    
    // MARK: - Sections
    
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
        
        let row1 = makeFinancialRow(
            financialCards[0],
            financialCards[1],
            tag: 100
        )
        
        let row2 = makeFinancialRow(
            financialCards[2],
            financialCards[3],
            tag: 101
        )
        
        return FormSection(
            id: Tags.Section.financialSummary.rawValue,
            cells: [row1, row2]
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
    
    // MARK: - Lazy Rows
    
    private lazy var filterRow: FormRow = makeFilterRowRow()
    private lazy var quickActionsRow: FormRow = makeQuickActionsRow()
    private lazy var quickActionsNoTitleRow: FormRow = makeQuickNoTitleActionsRow()
    private lazy var businessMetricsRow: FormRow = makeBusinessMetricsRow()
    
    // MARK: - Rows
    
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
                self?.goToFilter?()
            }
        )
        
        return TitleDropDownFilterFormRow(
            tag: Tags.Cells.filter.rawValue,
            model: model
        )
    }
    
    private func makeQuickActionsRow() -> FormRow {
        
        let sale = StatusCardViewModel(
            title: "Record Sale",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#22C55E")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56,
            onTapAction: { [weak self] in
                self?.goToRecordSales?()
            }
        )
        
        let expense = StatusCardViewModel(
            title: "Add Expense",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#EF4444")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80,
            onTapAction: { [weak self] in
                self?.goToAddExpense?()
            }
        )
        
        return TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                title: "Quick Actions",
                description: "Common bookeeping tasks",
                cards: TwoStatusCardsViewModel(
                    first: sale,
                    second: expense,
                    layout: .horizontal
                )
            )
        )
    }
    
    private func makeQuickNoTitleActionsRow() -> FormRow {
        
        let stock = StatusCardViewModel(
            title: "Manage Stock",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#3B82F6")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56,
            onTapAction: { [weak self] in
                self?.goToManageStock?()
            }
        )
        
        let reports = StatusCardViewModel(
            title: "View Reports",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#6366F1")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80,
            onTapAction: { [weak self] in
                self?.goToViewReports?()
            }
        )
        
        return TwoStatusCardsFormRow(
            tag: 101,
            model: TwoStatusCardsViewModel(
                first: stock,
                second: reports,
                layout: .horizontal
            )
        )
    }
    
    private func makeBusinessMetricsRow() -> FormRow {
        
        let customers = StatusCardViewModel(
            title: "Customers",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#A855F7")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56,
            onTapAction: { [weak self] in
                self?.goToCustomers?()
            }
        )
        
        let suppliers = StatusCardViewModel(
            title: "Suppliers",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#14B8A6")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80,
            onTapAction: { [weak self] in
                self?.goToSuppliers?()
            }
        )
        
        return TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                title: "Business Management",
                description: "Manage customers and suppliers",
                cards: TwoStatusCardsViewModel(
                    first: customers,
                    second: suppliers,
                    layout: .horizontal
                )
            )
        )
    }
    
    private func makeRecentActivitiesRow() -> [FormRow] {
        
        let sampleTransactions = [
            Transaction(title: "Salary", description: "January Salary", amount: "$5000", isIncome: true, icon: UIImage(systemName: "dollarsign.circle")),
            Transaction(title: "Rent", description: "Monthly rent", amount: "$1200", isIncome: false, icon: UIImage(systemName: "house")),
            Transaction(title: "Groceries", description: nil, amount: "$320", isIncome: false, icon: UIImage(systemName: "cart"))
        ]
        
        return makeTransactionRows(sampleTransactions)
    }
    
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
                    onTap: { },
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
    
    private struct State { }
    
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
