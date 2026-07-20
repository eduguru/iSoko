//
//  CustomersReportsViewModel.swift
//
//
//  Created by Edwin Weru on 08/03/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class CustomersReportsViewModel: FormViewModel {
    
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
    
    
    // MARK: - Search
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
                print("Failed to fetch customers report")
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
            
            let response = try await bookKeepingService.getAllCustomersReportByDate(
                startDate: state.startDate?.getYearMonthDay() ?? "",
                endDate: state.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )
            
            
            state.summary = response
            
            state.customers = response.history ?? []
            
            
            state.filteredCustomers = state.searchText.isEmpty
            ? state.customers
            : filterResults(state.customers)
            
            
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
                    self?.filterCustomers(text)
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

    private func filterCustomers(_ text: String) {
        
        state.searchText = text
        
        searchWorkItem?.cancel()
        
        let work = DispatchWorkItem { [weak self] in
            
            guard let self else {
                return
            }
            
            self.state.filteredCustomers = text.isEmpty
            ? self.state.customers
            : self.filterResults(self.state.customers)
            
            self.updateRecentActivitiesSection()
        }
        
        searchWorkItem = work
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.25,
            execute: work
        )
    }
    
    
    private func filterResults(
        _ customers: [CustomerHistoryResponse]
    ) -> [CustomerHistoryResponse] {
        
        let query = state.searchText.lowercased()
        
        return customers.filter {
            
            let name = $0.customer?.name?.lowercased() ?? ""
            let phone = $0.customer?.phoneNumber?.lowercased() ?? ""
            let id = String($0.customer?.id ?? 0)
            
            return name.contains(query)
            || phone.contains(query)
            || id.contains(query)
        }
    }
    
    
    // MARK: - Financial Summary

    private func makeFinancialSummaryRow() -> FormRow {
        
        let totalCustomers = state.summary?.customers ?? 0
        let newCustomers = state.summary?.newCustomers ?? 0
        
        let config = DualCardCellConfig(
            
            left: DualCardItemConfig(
                title: "Total Customers",
                titleIcon: nil,
                subtitle: "\(totalCustomers)",
                status: CardStatusStyle(
                    text: "All customers",
                    textColor: .systemBlue,
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "person.3")
                )
            ),
            
            right: DualCardItemConfig(
                title: "New Customers",
                titleIcon: nil,
                subtitle: "\(newCustomers)",
                status: CardStatusStyle(
                    text: "Recently added",
                    textColor: .systemGreen,
                    backgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "person.badge.plus")
                )
            )
        )
        
        return DualCardFormRow(
            tag: Tags.Cells.financialSummary.rawValue,
            config: config
        )
    }
    
    
    // MARK: - Customer Rows

    private func makeTransactionActionRows() -> [FormRow] {
        
        state.filteredCustomers.map { history in
            
            let customer = history.customer
            
            let name = customer?.name ?? "Unnamed Customer"
            let phone = customer?.phoneNumber ?? "No phone"
            
            let purchases = history.sales ?? 0
            let amount = history.amount ?? 0
            
            let currency = countryHelper.currencyString(
                for: AppStorage.selectedRegionCode ?? ""
            )
            
            
            let config = TransactionActionsCellConfig(
                
                title: name,
                subtitle: phone,
                amount: "\(currency) \(Int(amount))",
                amountColor: .label,
                status: "\(purchases) Purchases",
                statusColor: .app(.hex("#717171")),
                
                primaryAction: ActionCardConfig(
                    title: "View History",
                    icon: UIImage(systemName: "clock"),
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    textColor: .app(.hex("#656C7A")),
                    onTap: { [weak self] in
                        self?.goToDetails?()
                    }
                ),
                
                secondaryAction: InlineActionConfig(
                    title: "common.action.edit".localized,
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit customer \(customer?.id ?? 0)")
                    }
                )
            )
            
            
            return TransactionActionsRow(
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
            
            self.fetchData()
        }
    }
    
    
    // MARK: - State

    private struct State {
        
        var payload: ReportSelectionPayload
        
        var customers: [CustomerHistoryResponse] = []
        var filteredCustomers: [CustomerHistoryResponse] = []
        
        var summary: CustomerReportResponse?
        
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
