//
//  BookKeepingSalesViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class BookKeepingSalesViewModel: FormViewModel {

    // MARK: - Navigation
    var goToDetails: ((SalesResponse) -> Void)? = { _ in }

    // MARK: - State
    private var state = State()

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    @MainActor private let countryHelper = CountryHelper()

    // MARK: - Init
    override init() {
        super.init()
        
        Task { @MainActor in
            self.sections = makeSections()
        }
    }

    // MARK: - Fetch
    override func fetchData() {
        showLoader()
        defer { hideLoader() }
        
        Task {
            let success = await fetchItems()

            if !success {
                print("Failed to fetch sales data")
            }

            await MainActor.run { [weak self] in
                self?.updateRecentActivitiesSection()
                self?.updateFinancialSummarySection()
            }
        }
    }

    // MARK: - Network
    private func fetchItems() async -> Bool {
        async let sales = performNetworkRequest()
        let results = await [sales]
        return results.allSatisfy { $0 }
    }

    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllSales(
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )

            state.sales = response.data
            state.filteredSales = response.data

            return true

        } catch {
            print("❌ Error: ", error)
            return false
        }
    }

    // MARK: - Section Updates
    private func updateRecentActivitiesSection() {
        updateSection(id: Tags.Section.recentActivities.rawValue, cells: makeTransactionActionRows())
    }

    private func updateFinancialSummarySection() {
        updateSection(id: Tags.Section.financialSummary.rawValue, cells: [makeFinancialSummaryRow()])
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
            cells: [searchRow]
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

    // MARK: - Rows (Lazy)
    private lazy var financialSummaryRow: FormRow = makeFinancialSummaryRow()
    private lazy var searchRow: FormRow = makeSearchRow()

    // MARK: - Search Row
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
    
    private var searchWorkItem: DispatchWorkItem?

    private func filterSales(_ text: String) {
        state.searchText = text

        searchWorkItem?.cancel()

        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }

            let query = text.lowercased()

            self.state.filteredSales = query.isEmpty
                ? self.state.sales
                : self.state.sales.filter {
                    ($0.customer?.name?.lowercased().contains(query) ?? false)
                    || ($0.type?.name?.lowercased().contains(query) ?? false)
                    || String($0.id ?? 0).contains(query)
                }

            self.updateRecentActivitiesSection()
            self.updateFinancialSummarySection()
        }

        searchWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: work)
    }

    // MARK: - Financial Summary
    private func makeFinancialSummaryRow() -> FormRow {

        let sales = state.filteredSales

        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        let totalAmount: Double = sales.compactMap { $0.totalAmount }.reduce(0, +)
        let totalSales = sales.count

        let totalText = "\(currency). \(Int(totalAmount))"
        let countText = "\(totalSales)"

        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Sales",
                titleIcon: UIImage(systemName: "chart.bar"),
                subtitle: totalText,
                status: CardStatusStyle(
                    text: "Revenue",
                    textColor: .systemGreen,
                    backgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "arrow.up")
                )
            ),
            right: DualCardItemConfig(
                title: "Transactions",
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

    // MARK: - Transactions Mapping (REAL DATA)
    private func makeTransactionActionRows() -> [FormRow] {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")

        return state.filteredSales.map { sale in

            let amount = sale.totalAmount ?? 0
            let amountText = "\(currency). \(amount)"

            let customerName = sale.customer?.name ?? "Walk-in Customer"
            let saleType = sale.type?.name ?? "Sale"

            let paymentMethod = sale.paymentMethod?.name ?? "Unknown"
            let dateText = formatDate(sale)

            let config = TransactionSummaryCellConfig(
                title: customerName,
                amount: amountText,
                amountColor: .systemGreen,
                dateText: dateText,
                saleTypeText: saleType,
                saleTypeTextColor: .white,
                saleTypeBackgroundColor: .systemBlue,

                // API no longer returns items, so show payment method instead
                itemsCountText: paymentMethod,

                primaryAction: ActionCardConfig(
                    title: "common.action.view_details".localized,
                    icon: UIImage(systemName: "eye.fill"),
                    backgroundColor: .white,
                    textColor: .label,
                    borderColor: .systemGray4,
                    borderWidth: 1,
                    onTap: { [weak self] in
                        self?.goToDetails?(sale)
                    }
                ),

                secondaryAction: InlineActionConfig(
                    title: "common.action.edit".localized,
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit sale \(sale.id)")
                    }
                ),

                cardBackgroundColor: .white,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )

            return TransactionSummaryRow(tag: sale.id, config: config)
        }
    }

    // MARK: - Helpers
    private func formatDate(_ sale: SalesResponse) -> String {
        guard let date = sale.saleDate else { return "" }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // MARK: - State
    private struct State {
        var sales: [SalesResponse] = []          // Original API response
        var filteredSales: [SalesResponse] = []  // What the UI displays

        var searchText = ""

        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
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
