//
//  ExpensesReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class ExpensesReportsViewModel: FormViewModel {
    
    // MARK: - Navigation
    
    var goToDetails: (() -> Void)?
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }
    
    var goToDateSelection: (
        DatePickerConfig,
        @escaping (Date?) -> Void
    ) -> Void = { _, _ in }
    
    var gotoSelectSystemCountry: (
        CommonUtilityOption,
        _ completion: @escaping (CountryResponse?) -> Void
    ) -> Void = { _, _ in }
    
    var gotoConfirm: (() -> Void)?
    
    var goToAddCategory: (() -> Void)? = { }
    
    
    // MARK: - Services
    
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    @MainActor
    private let countryHelper = CountryHelper()
    
    private var searchWorkItem: DispatchWorkItem?
    
    
    // MARK: - State
    
    private var state: State
    
    
    // MARK: - Init
    
    init(payload: ReportSelectionPayload) {
        
        self.state = State(payload: payload)
        
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
            
            let response = try await bookKeepingService.getAllExpensesReportByDate(
                startDate: state.startDate?.getYearMonthDay() ?? "",
                endDate: state.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )
            
            
            state.expenses = response.history ?? []
            
            
            state.filteredExpenses = state.searchText.isEmpty
            ? state.expenses
            : filterResults(state.expenses)
            
            
            return true
            
            
        } catch {
            
            print("❌ Error: ", error)
            
            return false
        }
    }
    
    
    // MARK: - Section Updates
    
    private func updateRecentActivitiesSection() {
        
        updateSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: makeTransactionActionRows()
        )
    }
    
    
    private func updateFinancialSummarySection() {
        
        updateSection(
            id: Tags.Section.financialSummary.rawValue,
            cells: [
                makeFinancialSummaryRow()
            ]
        )
    }
    
    
    private func updateFilterSection() {
        
        updateSection(
            id: Tags.Section.search.rawValue,
            cells: [
                searchRow,
                makeFilterFormRow()
            ]
        )
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
            cells: [
                searchRow,
                makeFilterFormRow()
            ]
        )
    }
    
    
    private func makeFinancialSummarySection() -> FormSection {
        
        FormSection(
            id: Tags.Section.financialSummary.rawValue,
            cells: [
                financialSummaryRow
            ]
        )
    }
    
    
    private func makeRecentActivitiesSection() -> FormSection {
        
        FormSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: makeTransactionActionRows()
        )
    }
    
    
    // MARK: - Rows
    
    private lazy var searchRow: FormRow = makeSearchRow()
    
    private lazy var financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    
    
    private func makeSearchRow() -> FormRow {
        
        SearchFormRow(
            tag: Tags.Cells.search.rawValue,
            model: SearchFormModel(
                placeholder: "common.label.search".localized,
                keyboardType: .default,
                searchIcon: UIImage(systemName: "magnifyingglass"),
                searchIconPlacement: .right,
                filterIcon: nil,
                didTapSearchIcon: {},
                didTapFilterIcon: {},
                onTextChanged: { [weak self] text in
                    self?.filterExpenses(text)
                }
            )
        )
    }
    
    // MARK: - Search

    private func filterExpenses(_ text: String) {

        state.searchText = text

        searchWorkItem?.cancel()

        let work = DispatchWorkItem { [weak self] in

            guard let self else {
                return
            }


            self.state.filteredExpenses = text.isEmpty
            ? self.state.expenses
            : self.filterResults(self.state.expenses)


            self.updateRecentActivitiesSection()
            self.updateFinancialSummarySection()
        }


        searchWorkItem = work


        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.25,
            execute: work
        )
    }



    private func filterResults(
        _ expenses: [ExpenseHistoryResponse]
    ) -> [ExpenseHistoryResponse] {

        let query = state.searchText.lowercased()


        return expenses.filter {

            let category = $0.category?.name?.lowercased() ?? ""
            let date = $0.date?.lowercased() ?? ""
            let amount = String($0.amount ?? 0)


            return category.contains(query)
            || date.contains(query)
            || amount.contains(query)
        }
    }



    // MARK: - Financial Summary

    private func makeFinancialSummaryRow() -> FormRow {


        let expenses = state.filteredExpenses


        let currency = countryHelper.currencyString(
            for: AppStorage.selectedRegionCode ?? ""
        )


        let totalAmount = expenses
            .compactMap { $0.amount }
            .reduce(0, +)


        let count = expenses.count



        let config = DualCardCellConfig(

            left: DualCardItemConfig(
                title: "Total Expenses",
                titleIcon: UIImage(systemName: "chart.bar"),
                subtitle: "\(currency). \(Int(totalAmount))",
                status: CardStatusStyle(
                    text: totalAmount >= 0
                    ? "Net Positive"
                    : "Net Negative",
                    textColor: totalAmount >= 0
                    ? .systemGreen
                    : .systemRed,
                    backgroundColor: (
                        totalAmount >= 0
                        ? UIColor.systemGreen
                        : UIColor.systemRed
                    ).withAlphaComponent(0.15),
                    icon: UIImage(
                        systemName: totalAmount >= 0
                        ? "arrow.up"
                        : "arrow.down"
                    )
                )
            ),


            right: DualCardItemConfig(
                title: "Number of Expenses",
                titleIcon: UIImage(systemName: "doc.text"),
                subtitle: "\(count)",
                status: CardStatusStyle(
                    text: "Total entries",
                    textColor: .systemBlue,
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "list.number")
                )
            )
        )


        return DualCardFormRow(
            tag: Tags.Cells.financialSummary.rawValue,
            config: config
        )
    }



    // MARK: - Filters

    private func makeFilterFormRow() -> FormRow {

        FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "common.label.filters".localized,
                rows: [

                    [

                        FilterFieldConfig(
                            placeholder: "common.label.category".localized,
                            selectedValue: state.selectedCategory?.name,
                            onTap: { [weak self] in
                                self?.handleCategorySelection()
                            }
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
                            onTap: { [weak self] in
                                self?.handleStartDateSelection()
                            }
                        ),


                        FilterFieldConfig(
                            placeholder: "common.label.end_date".localized,
                            selectedValue: state.endDateString,
                            onTap: { [weak self] in
                                self?.handleEndDateSelection()
                            }
                        )
                    ]
                ],
                message: "",
                showsCard: false
            )
        )
    }



    // MARK: - Selection Handlers

    private func handleCategorySelection() {

        goToCommonSelectionOptions(
            .expenses(page: 0, count: 10),
            nil
        ) { [weak self] value in

            guard let self else {
                return
            }


            self.state.selectedCategory = value

            self.updateFilterSection()

            self.fetchData()
        }
    }



    private func handlePaymentSelection() {

        goToCommonSelectionOptions(
            .paymentOptions(page: 0, count: 10),
            nil
        ) { [weak self] value in

            guard let self else {
                return
            }


            self.state.selectedPaymentMethod = value

            self.updateFilterSection()

            self.fetchData()
        }
    }



    private func handleStartDateSelection() {

        goToDateSelection(.year()) { [weak self] date in

            guard let self, let date else {
                return
            }


            self.state.startDate = date
            self.state.startDateString = Helpers.format(date)

            self.updateFilterSection()

            self.fetchData()
        }
    }



    private func handleEndDateSelection() {

        goToDateSelection(.year()) { [weak self] date in

            guard let self, let date else {
                return
            }


            self.state.endDate = date
            self.state.endDateString = Helpers.format(date)

            self.updateFilterSection()

            self.fetchData()
        }
    }



    // MARK: - Expense Rows

    private func makeTransactionActionRows() -> [FormRow] {


        state.filteredExpenses.map { expense in


            let currency = countryHelper.currencyString(
                for: AppStorage.selectedRegionCode ?? ""
            )


            let amountText = expense.amount.map {
                "\(currency). \($0)"
            } ?? "\(currency). 0"


            let categoryName = expense.category?.name
            ?? "common.label.expense".localized


            let dateText = expense.date ?? ""



            let config = TransactionSummaryCellConfig(

                title: categoryName,

                amount: amountText,

                amountColor: .label,

                dateText: dateText,

                saleTypeText: categoryName,

                saleTypeTextColor: .white,

                saleTypeBackgroundColor: .systemBlue,

                itemsCountText: "",


                primaryAction: ActionCardConfig(
                    title: "common.action.view_details".localized,
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
                    title: "common.action.edit".localized,
                    icon: UIImage(systemName: "pencil"),

                    onTap: {
                        print("Edit expense")
                    }
                ),


                cardBackgroundColor: .white,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )


            return TransactionSummaryRow(
                tag: expense.date?.hashValue ?? UUID().hashValue,
                config: config
            )
        }
    }



    // MARK: - State

    private struct State {


        var payload: ReportSelectionPayload


        var expenses: [ExpenseHistoryResponse] = []

        var filteredExpenses: [ExpenseHistoryResponse] = []


        var selectedCategory: CommonIdNameModel?

        var selectedPaymentMethod: CommonIdNameModel?



        var startDate: Date?

        var endDate: Date?


        var startDateString: String?

        var endDateString: String?


        var searchText = ""



        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false

        var userProfile: UserDetails? = AppStorage.userDetail

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""

        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""



        init(payload: ReportSelectionPayload) {

            self.payload = payload


            self.startDate = payload.startDate

            self.endDate = payload.endDate



            self.startDateString = payload.startDate.map {

                Helpers.format($0)

            }



            self.endDateString = payload.endDate.map {

                Helpers.format($0)

            }
        }
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

            case financialSummary = 1
        }
    }
}
