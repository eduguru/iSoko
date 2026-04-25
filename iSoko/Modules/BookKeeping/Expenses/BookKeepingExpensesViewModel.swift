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
    
    // MARK: - Navigation
    var goToDetails: (() -> Void)?
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }
    
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }

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
                self.updateFinancialSummarySection()
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

            self.state.expenses = response.data ?? []
            return true

        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    // MARK: - Section Updates
    private func updateRecentActivitiesSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.recentActivities.rawValue
        }) else { return }
        
        sections[index].cells = makeTransactionActionRows()
        reloadSection(index)
    }

    private func updateFilterSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.search.rawValue
        }) else { return }
        
        sections[index].cells = [searchRow, makeFilterFormRow()]
        reloadSection(index)
    }
    
    private func updateFinancialSummarySection() {

        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.financialSummary.rawValue
        }) else { return }

        sections[index].cells = [makeFinancialSummaryRow()]
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
            cells: [searchRow, makeFilterFormRow()]
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
    private lazy var searchRow = makeSearchRow()
    
    private func makeFinancialSummaryRow() -> FormRow {

        let expenses = state.expenses

        // Total = raw sum from backend (already signed correctly)
        let totalAmount: Double = expenses.compactMap { $0.amount }.reduce(0, +)

        let count = expenses.count

        let totalText = "Ksh. \(Int(totalAmount))"
        let countText = "\(count)"

        let subtitle = buildSummarySubtitle()

        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Expenses",
                titleIcon: UIImage(systemName: "chart.bar"),
                subtitle: totalText,
                status: CardStatusStyle(
                    text: totalAmount >= 0 ? "Net Positive" : "Net Negative",
                    textColor: totalAmount >= 0 ? .systemGreen : .systemRed,
                    backgroundColor: (totalAmount >= 0
                        ? UIColor.systemGreen
                        : UIColor.systemRed
                    ).withAlphaComponent(0.15),
                    icon: UIImage(systemName: totalAmount >= 0 ? "arrow.up" : "arrow.down")
                )
            ),
            right: DualCardItemConfig(
                title: "Number of Expenses",
                titleIcon: UIImage(systemName: "doc.text"),
                subtitle: countText,
                status: CardStatusStyle(
                    text: "Total entries",
                    textColor: .systemBlue,
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "list.number")
                )
            )
        )

        return DualCardFormRow(tag: 100, config: config)
    }
    
    private func buildSummarySubtitle() -> String {

        guard let start = state.startDate, let end = state.endDate else {
            return "All time"
        }

        return DateFormatters.displayRange(start: start, end: end)
    }
    
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
                            placeholder: "Category",
                            selectedValue: state.selectedCategory?.name,
                            onTap: { [weak self] in self?.handleCategorySelection() }
                        ),
                        FilterFieldConfig(
                            placeholder: "Payment Method",
                            selectedValue: state.selectedPaymentMethod?.name,
                            onTap: { [weak self] in
                                self?.handlePaymentSelection()
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Start Date",
                            selectedValue: state.startDateString,
                            onTap: { [weak self] in self?.handleStartDateSelection() }
                        ),
                        FilterFieldConfig(
                            placeholder: "End Date",
                            selectedValue: state.endDateString,
                            onTap: { [weak self] in self?.handleEndDateSelection() }
                        )
                    ]
                ],
                message: "Select filters to refine your results",
                showsCard: false
            )
        )
    }
    
    // MARK: - Selection Handlers (COPIED + ADAPTED)
    
    private func handleCategorySelection() {
        goToCommonSelectionOptions(.expenses(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.selectedCategory = value
            self.updateFilterSection()
            self.fetchData()
        }
    }
    
    private func handlePaymentSelection() {
        goToCommonSelectionOptions(.paymentOptions(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.selectedPaymentMethod = value
            self.updateFilterSection()
            self.fetchData()
        }
    }
    
    private func handleStartDateSelection() {
        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }

            self.state.startDate = date
            self.state.startDateString = Self.format(date)

            self.updateFilterSection()
            self.fetchData()
        }
    }
    
    private func handleEndDateSelection() {
        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }

            self.state.endDate = date
            self.state.endDateString = Self.format(date)

            self.updateFilterSection()
            self.fetchData()
        }
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
                itemsCountText: "",
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

            return TransactionSummaryRow(tag: expense.id, config: config)
        }
    }
    
    // MARK: - Helpers
    private func formatDate(_ expense: ExpenseResponse) -> String {
        expense.expenseDate ?? expense.createdOn ?? ""
    }
    
    private static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // MARK: - State
    private struct State {
        var expenses: [ExpenseResponse] = []

        var selectedCategory: CommonIdNameModel?
        var selectedPaymentMethod: CommonIdNameModel?
        
        var startDate: Date?
        var endDate: Date?
        
        var startDateString: String?
        var endDateString: String?

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case search = 0
            case financialSummary = 1
            case recentActivities = 2
        }

        enum Cells: Int {
            case search = 0
        }
    }
}
