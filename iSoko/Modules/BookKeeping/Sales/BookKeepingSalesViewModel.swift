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

final class BookKeepingSalesViewModel: FormViewModel {

    // MARK: - Navigation
    var goToDetails: (() -> Void)?

    // MARK: - State
    private var state = State()

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    // MARK: - Init
    override init() {
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Fetch
    override func fetchData() {
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

            self.state.sales = response.data

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

    // MARK: - Financial Summary
    private func makeFinancialSummaryRow() -> FormRow {

        let sales = state.sales

        let totalAmount: Double = sales.compactMap { $0.totalAmount }.reduce(0, +)
        let totalSales = sales.count

        let totalText = "Ksh. \(Int(totalAmount))"
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
        state.sales.map { sale in

            let amountText = sale.totalAmount.map { "Ksh. \($0)" } ?? "Ksh. 0"

            let customerName = sale.customer?.name ?? "Walk-in Customer"
            let saleType = sale.type?.name ?? "Sale"

            let itemsCount = sale.items?.count ?? 0
            let itemsText = "\(itemsCount) item\(itemsCount == 1 ? "" : "s")"

            let dateText = formatDate(sale)

            let config = TransactionSummaryCellConfig(
                title: customerName,
                amount: amountText,
                amountColor: .systemGreen,
                dateText: dateText,
                saleTypeText: saleType,
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
        var sales: [SalesResponse] = []

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
            case recentActivities = 2
        }

        enum Cells: Int {
            case search = 0
        }
    }
}
