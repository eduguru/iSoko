//
//  BookKeepingExpensesViewModel.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingExpensesViewModel: FormViewModel {
    
    var goToDetails: (() -> Void)? = { }
    
    private var state = State()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    override init() {
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await performNetworkRequest()

            if !success {
                print("Failed to fetch expenses")
            }

            await MainActor.run {
                self.updateRecentActivitiesSection()
            }
        }
    }
    
    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllExpenses(
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )

            // Store real data
            self.state.expenses = response.data ?? []

            return true

        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    // MARK: - Update Section
    private func updateRecentActivitiesSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.recentActivities.rawValue
        }) else { return }
        
        sections[index].cells = makeTransactionActionRows()
        reloadSection(index)
    }

    // MARK: - Sections
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
            cells: [searchRow, filterFormRow]
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
    
    // MARK: - Rows
    private lazy var financialSummaryRow: FormRow = makeFinancialSummaryRow()
    private lazy var filterFormRow: FormRow = makeFilterFormRow()
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
    
    private func makeFilterFormRow() -> FormRow {
        FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "Filters",
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Sale Type",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: { print("Sale Type tapped") }
                        ),
                        FilterFieldConfig(
                            placeholder: "Time Period",
                            selectedValue: nil,
                            iconSystemName: "calendar",
                            onTap: { print("Time Period tapped") }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Region",
                            selectedValue: nil,
                            iconSystemName: "mappin.and.ellipse",
                            onTap: { print("Region tapped") }
                        )
                    ]
                ],
                message: "Select filters to refine your results"
            )
        )
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Expenses",
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
                title: "Pending Review",
                titleIcon: UIImage(systemName: "doc.text"),
                subtitle: "2 pending",
                status: CardStatusStyle(
                    text: "Action needed",
                    textColor: .systemOrange,
                    backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "exclamationmark.triangle")
                )
            )
        )

        return DualCardFormRow(tag: 100, config: config)
    }
    
    // MARK: - Rows from API
    private func makeTransactionActionRows() -> [FormRow] {
        state.expenses.map { expense in
            
            let amountText = expense.amount.map { "Ksh. \($0)" } ?? "Ksh. 0"
            let dateText = formatDate(expense)
            let supplierName = expense.supplier?.name ?? "Unknown Supplier"
            let categoryName = expense.category?.name ?? "Expense"
            
            let config = TransactionSummaryCellConfig(
                title: supplierName,
                amount: amountText,
                amountColor: .label,
                dateText: dateText,
                saleTypeText: categoryName,
                saleTypeTextColor: .white,
                saleTypeBackgroundColor: .systemBlue,
                itemsCountText: expense.description ?? "",
                primaryAction: ActionCardConfig(
                    title: "View Details",
                    icon: UIImage(systemName: "eye.fill"),
                    backgroundColor: .white,
                    textColor: .label,
                    borderColor: .systemGray4,
                    borderWidth: 1,
                    onTap: { [weak self] in
                        self?.goToDetails?()
                    }
                ),
                secondaryAction: InlineActionConfig(
                    title: "Edit",
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit expense \(expense.id)")
                    }
                ),
                cardBackgroundColor: .white,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )

            return TransactionSummaryRow(
                tag: expense.id,
                config: config
            )
        }
    }
    
    // MARK: - Helpers
    private func formatDate(_ expense: ExpenseResponse) -> String {
        return expense.expenseDate ?? expense.createdOn ?? ""
    }

    // MARK: - State
    private struct State {
        var expenses: [ExpenseResponse] = []

        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userProfile
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
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
