//
//  SuppliersReportsViewModel.swift
//
//
//  Created by Edwin Weru on 08/03/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class SuppliersReportsViewModel: FormViewModel {
    
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
                print("Failed to fetch suppliers report")
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
            
            let response = try await bookKeepingService.getAllSuppliersReportByDate(
                startDate: state.startDate?.getYearMonthDay() ?? "",
                endDate: state.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )
            
            state.summary = response
            
            state.suppliers = response.history ?? []
            
            state.filteredSuppliers = state.searchText.isEmpty
            ? state.suppliers
            : filterResults(state.suppliers)
            
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
                    self?.filterSuppliers(text)
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
    private func filterSuppliers(_ text: String) {
        
        state.searchText = text
        
        searchWorkItem?.cancel()
        
        let work = DispatchWorkItem { [weak self] in
            
            guard let self else { return }
            
            self.state.filteredSuppliers = text.isEmpty
            ? self.state.suppliers
            : self.filterResults(self.state.suppliers)
            
            self.updateRecentActivitiesSection()
        }
        
        searchWorkItem = work
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.25,
            execute: work
        )
    }
    
    
    private func filterResults(
        _ suppliers: [SupplierHistoryResponse]
    ) -> [SupplierHistoryResponse] {
        
        let query = state.searchText.lowercased()
        
        return suppliers.filter {
            
            let name = $0.supplier?.name?.lowercased() ?? ""
            let phone = $0.supplier?.phoneNumber?.lowercased() ?? ""
            let id = String($0.supplier?.id ?? 0)
            
            
            return name.contains(query)
            || phone.contains(query)
            || id.contains(query)
        }
    }
    
    // MARK: - Financial Summary

    private func makeFinancialSummaryRow() -> FormRow {
        let currency = countryHelper.currencyString(
            for: AppStorage.selectedRegionCode ?? ""
        )

        let totalSuppliers = state.summary?.suppliers ?? 0
        let totalAmount = state.summary?.amount ?? 0

        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Suppliers",
                titleIcon: nil,
                subtitle: "\(totalSuppliers)",
                status: CardStatusStyle(
                    text: "All suppliers",
                    textColor: .systemBlue,
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "person.3")
                )
            ),

            right: DualCardItemConfig(
                title: "Total Supplied",
                titleIcon: nil,
                subtitle: "\(currency). \(Int(totalAmount))",
                status: CardStatusStyle(
                    text: totalAmount >= 0 ? "Positive" : "Negative",
                    textColor: totalAmount >= 0 ? .systemGreen : .systemRed,
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
            )
        )

        return DualCardFormRow(
            tag: Tags.Cells.financialSummary.rawValue,
            config: config
        )
    }


    // MARK: - Supplier Report Rows

    private func makeTransactionActionRows() -> [FormRow] {

        state.filteredSuppliers.map { history in

            let supplier = history.supplier

            let currency = countryHelper.currencyString(
                for: AppStorage.selectedRegionCode ?? ""
            )

            let name = supplier?.name ?? "Unknown Supplier"
            let phone = supplier?.phoneNumber ?? "No phone"

            let amount = history.amount ?? 0
            let items = history.items ?? 0


            let config = TransactionActionsCellConfig(
                title: name,
                subtitle: phone,
                amount: "\(currency). \(Int(amount))",
                amountColor: .label,
                status: "\(items) items supplied",
                statusColor: .darkGray,
                primaryAction: ActionCardConfig(
                    title: "common.action.view_details".localized,
                    icon: UIImage(systemName: "eye"),
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    textColor: .app(.primary),
                    onTap: { [weak self] in
                        self?.goToDetails?()
                    }
                ),
                secondaryAction: InlineActionConfig(
                    title: "common.action.edit".localized,
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit supplier \(supplier?.id ?? 0)")
                    }
                )
            )

            return TransactionActionsRow(
                tag: supplier?.id ?? UUID().hashValue,
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

        var suppliers: [SupplierHistoryResponse] = []
        var filteredSuppliers: [SupplierHistoryResponse] = []

        var summary: SupplierReportResponse?

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
