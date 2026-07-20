//
//  BookKeepingSuppliesViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class BookKeepingSuppliesViewModel: FormViewModel {

    // MARK: - Navigation
    var goToDetails: ((SupplierResponse) -> Void)? = { _ in }

    // MARK: - State
    private var state = State()

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    @MainActor private let countryHelper = CountryHelper()

    private var searchWorkItem: DispatchWorkItem?

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

        Task {
            let success = await performNetworkRequest()

            await MainActor.run {
                self.hideLoader()

                if !success {
                    print("Failed to fetch suppliers")
                }

                self.updateRecentActivitiesSection()
            }
        }
    }

    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllSuppliers(
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )

            state.suppliers = response.data ?? []
            state.filteredSuppliers = state.suppliers

            return true

        } catch {
            print("❌ Error: ", error)
            return false
        }
    }

    // MARK: - Section Reload
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
            cells: [searchRow]
        )
    }

    private func makeFinancialSummarySection() -> FormSection {
        FormSection(
            id: Tags.Section.financialSummary.rawValue,
            cells: [makeFinancialSummaryRow()]
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

    // MARK: - Search

    private func filterSuppliers(_ text: String) {

        state.searchText = text

        searchWorkItem?.cancel()

        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }

            let query = text.lowercased()

            self.state.filteredSuppliers = query.isEmpty
                ? self.state.suppliers
                : self.state.suppliers.filter {

                    ($0.name?.lowercased().contains(query) ?? false)
                    || ($0.phoneNumber?.lowercased().contains(query) ?? false)
                    || String($0.id ?? 0).contains(query)
                }

            self.updateRecentActivitiesSection()
        }

        searchWorkItem = work

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.25,
            execute: work
        )
    }

    // MARK: - Financial Summary

    private func makeFinancialSummaryRow() -> FormRow {

        let currency = countryHelper.currencyString(
            for: AppStorage.selectedRegionCode ?? ""
        )

        let suppliers = state.filteredSuppliers

        let totalSuppliers = suppliers.count

        let totalAmount = suppliers.reduce(0.0) {
            $0 + ($1.totalAmountSupplied ?? 0)
        }

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

    // MARK: - Supplier Rows

    private func makeTransactionActionRows() -> [FormRow] {

        state.filteredSuppliers.map { supplier in

            let config = TransactionActionsCellConfig(
                title: supplier.name ?? "Unknown Supplier",
                subtitle: supplier.phoneNumber ?? "No phone",
                amount: supplier.totalAmountSupplied.map {
                    "$\($0)"
                } ?? "$0.00",
                amountColor: .label,
                status: "\(supplier.suppliesCount ?? 0) items supplied",
                statusColor: .darkGray,

                primaryAction: ActionCardConfig(
                    title: "common.action.view_details".localized,
                    icon: UIImage(systemName: "eye"),
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    textColor: .app(.primary),
                    onTap: { [weak self] in
                        self?.goToDetails?(supplier)
                    }
                ),

                secondaryAction: InlineActionConfig(
                    title: "common.action.edit".localized,
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit supplier \(supplier.id)")
                    }
                )
            )

            return TransactionActionsRow(
                tag: supplier.id ?? 0,
                config: config
            )
        }
    }

    // MARK: - State

    private struct State {

        var suppliers: [SupplierResponse] = []
        var filteredSuppliers: [SupplierResponse] = []

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
