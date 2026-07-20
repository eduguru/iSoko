//
//  SalesReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import UIKit
import DesignSystemKit
import UtilsKit
import StorageKit

@MainActor
final class SalesReportsViewModel: FormViewModel {
    
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
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    @MainActor private let countryHelper = CountryHelper()
    
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
                print("Failed to fetch sales")
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
            
            let response = try await bookKeepingService.getAllSalesReportByDate(
                customerId: state.userProfile?.sub ?? 0,
                startDate: state.startDate?.getYearMonthDay() ?? "",
                endDate: state.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )
            
            state.sales = response.history ?? []
            state.summary = response
            
            state.filteredSales = state.searchText.isEmpty
            ? state.sales
            : filterResults(state.sales)
            
            return true
            
        } catch {
            
            print("❌ Error: ", error)
            return false
        }
    }
    
    
    // MARK: - Section Update
    
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
                    self?.filterSales(text)
                }
            )
        )
    }
    
    private func makeFilterFormRow() -> FormRow {
        
        FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "",
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Sales Type",
                            selectedValue: nil,
                            onTap: {
                                print("Sales type tapped")
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Product",
                            selectedValue: nil,
                            onTap: {
                                print("Product tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "Payment Method",
                            selectedValue: nil,
                            onTap: {
                                print("Payment method tapped")
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
    
    
    // MARK: - Search
    
    private func filterSales(_ text: String) {
        
        state.searchText = text
        
        searchWorkItem?.cancel()
        
        let work = DispatchWorkItem { [weak self] in
            
            guard let self else {
                return
            }
            
            self.state.filteredSales = text.isEmpty
            ? self.state.sales
            : self.filterResults(self.state.sales)
            
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
        _ sales: [SalesHistoryResponse]
    ) -> [SalesHistoryResponse] {
        
        let query = state.searchText.lowercased()
        
        return sales.filter {
            
            let customerName = $0.customer?.name?.lowercased() ?? ""
            let phone = $0.customer?.phoneNumber?.lowercased() ?? ""
            let id = String($0.customer?.id ?? 0)
            
            return customerName.contains(query)
            || phone.contains(query)
            || id.contains(query)
        }
    }
    
    
    // MARK: - Financial Summary
    
    private func makeFinancialSummaryRow() -> FormRow {
        
        let totalSales = state.summary?.sales ?? 0
        let totalRevenue = state.summary?.revenue ?? 0
        
        let currency = countryHelper.currencyString(
            for: AppStorage.selectedRegionCode ?? ""
        )
        
        let config = DualCardCellConfig(
            
            left: DualCardItemConfig(
                title: "Total Sales",
                titleIcon: UIImage(systemName: "cart"),
                subtitle: "\(totalSales)",
                status: CardStatusStyle(
                    text: "Transactions",
                    textColor: .systemBlue,
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "cart.fill")
                )
            ),
            
            right: DualCardItemConfig(
                title: "Total Revenue",
                titleIcon: UIImage(systemName: "banknote"),
                subtitle: "\(currency). \(Int(totalRevenue))",
                status: CardStatusStyle(
                    text: totalRevenue >= 0 ? "Positive" : "Negative",
                    textColor: totalRevenue >= 0 ? .systemGreen : .systemRed,
                    backgroundColor: (
                        totalRevenue >= 0
                        ? UIColor.systemGreen
                        : UIColor.systemRed
                    ).withAlphaComponent(0.15),
                    icon: UIImage(
                        systemName: totalRevenue >= 0
                        ? "arrow.up"
                        : "arrow.down"
                    )
                )
            )
        )
        
        return DualCardFormRow(
            tag: Tags.Cells.financialSummary.rawValue,
            config: config
        )
    }
    
    
    // MARK: - Sale Rows
    
    private func makeTransactionActionRows() -> [FormRow] {
        
        state.filteredSales.map { sale in
            
            let customer = sale.customer
            
            let currency = countryHelper.currencyString(
                for: AppStorage.selectedRegionCode ?? ""
            )
            
            let name = customer?.name ?? "Walk-in Customer"
            let amount = sale.amount ?? 0
            let items = sale.items ?? 0
            let date = sale.date ?? ""
            
            let config = TransactionSummaryCellConfig(
                
                title: name,
                amount: "\(currency). \(Int(amount))",
                amountColor: .label,
                dateText: date,
                saleTypeText: "Sale",
                saleTypeTextColor: .white,
                saleTypeBackgroundColor: .systemBlue,
                itemsCountText: "\(items) items",
                
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
                        print("Edit sale for \(name)")
                    }
                ),
                
                cardBackgroundColor: .white,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )
            
            return TransactionSummaryRow(
                tag: customer?.id ?? UUID().hashValue,
                config: config
            )
        }
    }
    
    // MARK: - Date Selection
    
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
    
    
    private func updateFilterSection() {
        
        updateSection(
            id: Tags.Section.search.rawValue,
            cells: [
                searchRow,
                makeFilterFormRow()
            ]
        )
    }
    
    
    // MARK: - State
    
    private struct State {
        
        var payload: ReportSelectionPayload
        
        var sales: [SalesHistoryResponse] = []
        var filteredSales: [SalesHistoryResponse] = []
        
        var summary: SalesReportResponse?
        
        var searchText = ""
        
        var startDate: Date?
        var endDate: Date?
        
        var startDateString: String?
        var endDateString: String?
        
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
