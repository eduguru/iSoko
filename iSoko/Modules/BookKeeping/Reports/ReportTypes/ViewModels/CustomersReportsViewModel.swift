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

final class CustomersReportsViewModel: FormViewModel {
    var goToDetails: (() -> Void)?
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }
    
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    
    var gotoSelectSystemCountry: (
        CommonUtilityOption,
        _ completion: @escaping (CountryResponse?) -> Void
    ) -> Void = { _, _ in }
    
    var gotoConfirm: (() -> Void)?
    
    // MARK: - Service
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: - State
    private var state: State
    
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
                print("Failed to fetch suppliers")
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
                startDate: state.payload.startDate?.getYearMonthDay() ?? "",
                endDate: state.payload.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )
            
            self.state.customers = response.history ?? []
            self.state.summary = response
            
            return true
            
        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    private func updateRecentActivitiesSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.recentActivities.rawValue
        }) else { return }
        
        sections[index].cells = makeTransactionActionRows()
        
        reloadSection(index)
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
            cells: [
                searchRow,
                makeFilterFormRow()
            ]
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
    private func updateFilterSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.search.rawValue
        }) else { return }
        
        sections[index].cells = [
            searchRow,
            makeFilterFormRow()
        ]
        reloadSection(index)
    }
    
    private func updateFinancialSummarySection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.financialSummary.rawValue
        }) else { return }
        
        sections[index].cells = [makeFinancialSummaryRow()]
        reloadSection(index)
    }
    
    // MARK: - Lazy Rows
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private lazy var searchRow = makeSearchRow()
    
    
    
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
        
        return DualCardFormRow(tag: 100, config: config)
    }
    
    // Lazy factory that creates rows
    private func makeTransactionActionRows() -> [FormRow] {
        state.customers.map { history in
            
            let customer = history.customer
            
            let name = customer?.name ?? "Unnamed Customer"
            let phone = customer?.phoneNumber ?? "No phone"
            let purchasesCount = history.sales ?? 0
            let totalAmount = history.amount ?? 0
            
            let config = TransactionActionsCellConfig(
                title: name,
                subtitle: phone,
                amount: "Ksh \(Int(totalAmount))",
                amountColor: .label,
                status: "\(purchasesCount) Purchases",
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
                    title: "Edit",
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit tapped for \(name)")
                    }
                )
            )
            
            return TransactionActionsRow(
                tag: customer?.id ?? UUID().hashValue,
                config: config
            )
        }
    }
    
    // MARK: - Selection Handlers
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
    
    // MARK: - Helpers
    private static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - State
    private struct State {
        var payload: ReportSelectionPayload
        
        var customers: [CustomerHistoryResponse] = []
        var summary: CustomerReportResponse?       
        
        var startDate: Date?
        var endDate: Date?
        
        var startDateString: String?
        var endDateString: String?
        
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

