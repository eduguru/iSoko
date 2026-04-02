//
//  BookKeepingCustomersViewModel.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingCustomersViewModel: FormViewModel {
    var goToDetails: (() -> Void)? = { }
    
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
            let success = await fetchItems()
            
            if !success {
                print("Failed to fetch product data")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateRecentActivitiesSection()
            }
        }
    }
    
    // MARK: - Network
    
    private func fetchItems() async -> Bool {
        async let similar = performNetworkRequest()
        let results = await [similar]
        return results.allSatisfy { $0 }
    }
    
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllCustomers(
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )
            
            state.items = response.data
            
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
                title: "Total Customers",
                titleIcon: nil,
                subtitle: "140",
                status: CardStatusStyle(
                    text: "24% since last week",
                    textColor: .systemGreen,
                    backgroundColor: .app(.hex("#F0FFE5")),
                    icon: .stockmarketArrowUp
                )
            ),
            right: DualCardItemConfig(
                title: "Active Buyers",
                titleIcon: nil,
                subtitle: "23",
                status: CardStatusStyle(
                    text: "13% since last week",
                    textColor: .systemOrange,
                    backgroundColor: .app(.hex("#FFE5E6")),
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
        return state.items.enumerated().map { index, customer in
            
            let name = customer.name ?? "Unnamed Customer"
            let phone = customer.phoneNumber ?? "No phone"
            let purchasesCount = customer.purchasesCount ?? 0
            let totalAmount = customer.purchasesTotalAmount ?? 0.0
            
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
                        print("View history for \(name)")
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
                tag: index,
                config: config
            )
        }
    }
    
    // MARK: - State
    private struct State {
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userProfile
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var items: [CustomerResponse] = []
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
