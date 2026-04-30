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

final class BookKeepingSuppliesViewModel: FormViewModel {
   var goToDetails: ((SupplierResponse) -> Void)? = { _ in }
    
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
                print("Failed to fetch suppliers")
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
            let response = try await bookKeepingService.getAllSuppliers(
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )

            // store real data
            self.state.suppliers = response.data ?? []

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
    
    // MARK: - Update Sections -

    // MARK: - Lazy Rows
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private lazy var searchRow = makeSearchRow()
    
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
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Suppliers",
                titleIcon: nil,
                subtitle: "36",
                status: CardStatusStyle(
                    text: "24% since last week",
                    textColor: .systemGreen,
                    backgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                    icon: .stockmarketArrowUp
                )
            ),
            right: DualCardItemConfig(
                title: "Active Suppliers",
                titleIcon: nil,
                subtitle: "2",
                status: CardStatusStyle(
                    text: "24% since last week",
                    textColor: .systemOrange,
                    backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                    icon: .stockmarketArrowDown
                )
            )
        )

        let row = DualCardFormRow(
            tag: 100,
            config: config
        )

        return row
    }
    
    // Lazy factory that creates rows
    private func makeTransactionActionRows() -> [FormRow] {
        state.suppliers.map { supplier in

            let hasActions = true // (supplier.id % 2 == 0)

            let config = TransactionActionsCellConfig(
                title: supplier.name ?? "Unknown Supplier",
                subtitle: supplier.phoneNumber ?? "No phone",
                amount: supplier.totalAmountSupplied.map { "$\($0)" } ?? "$0.00",
                amountColor: .label,
                status: "\(supplier.suppliesCount ?? 0) items supplied",
                statusColor: .darkGray,
                primaryAction: hasActions
                    ? ActionCardConfig(
                        title: "View Details",
                        icon: UIImage(systemName: "eye"),
                        backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                        textColor: .app(.primary),
                        onTap: { [weak self] in
                            self?.goToDetails?(supplier)
                        }
                    )
                    : nil,
                secondaryAction: hasActions
                    ? InlineActionConfig(
                        title: "Edit",
                        icon: UIImage(systemName: "pencil"),
                        onTap: {
                            print("Edit supplier \(supplier.id)")
                        }
                    )
                    : nil
            )

            return TransactionActionsRow(
                tag: supplier.id,
                config: config
            )
        }
    }

    // MARK: - State
    private struct State {
        var suppliers: [SupplierResponse] = []

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

