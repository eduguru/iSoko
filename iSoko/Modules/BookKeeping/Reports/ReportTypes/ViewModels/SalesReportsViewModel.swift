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

final class SalesReportsViewModel: FormViewModel {
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
            let response = try await bookKeepingService.getAllSalesReportByDate(
                customerId: state.userProfile?.sub ?? 0,
                startDate: state.payload.startDate?.getYearMonthDay() ?? "",
                endDate: state.payload.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )
            
            self.state.sales = response.history ?? []
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
                            placeholder: "Sales Type",
                            selectedValue: nil,
                            onTap: {
                                print("tapped")
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Product",
                            selectedValue: nil,
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "Payment Method",
                            selectedValue: nil,
                            onTap: {
                                print("Time Period tapped")
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
                message: "",
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
        
        let totalSales = state.summary?.sales ?? 0
        let totalRevenue = state.summary?.revenue ?? 0
        
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
                subtitle: "Ksh. \(Int(totalRevenue))",
                status: CardStatusStyle(
                    text: totalRevenue >= 0 ? "Positive" : "Negative",
                    textColor: totalRevenue >= 0 ? .systemGreen : .systemRed,
                    backgroundColor: (totalRevenue >= 0
                                      ? UIColor.systemGreen
                                      : UIColor.systemRed
                                     ).withAlphaComponent(0.15),
                    icon: UIImage(systemName: totalRevenue >= 0 ? "arrow.up" : "arrow.down")
                )
            )
        )
        
        return DualCardFormRow(tag: 100, config: config)
    }
    
    // Lazy factory that creates rows
    private func makeTransactionActionRows() -> [FormRow] {
        state.sales.map { sale in
            
            let customer = sale.customer
            
            let name = customer?.name ?? "Walk-in Customer"
            let phone = customer?.phoneNumber ?? ""
            let amountText = sale.amount.map { "Ksh. \($0)" } ?? "Ksh. 0"
            let itemsText = "\(sale.items ?? 0) items"
            let dateText = sale.date ?? ""
            
            let config = TransactionSummaryCellConfig(
                title: name,
                amount: amountText,
                amountColor: .label,
                dateText: dateText,
                saleTypeText: "Sale",
                saleTypeTextColor: .white,
                saleTypeBackgroundColor: .systemBlue,
                itemsCountText: itemsText,
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
        
        var sales: [SalesHistoryResponse] = []
        var summary: SalesReportResponse?
        
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

