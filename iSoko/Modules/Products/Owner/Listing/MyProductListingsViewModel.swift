//
//  MyProductListingsViewModel.swift
//  
//
//  Created by Edwin Weru on 26/03/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class MyProductListingsViewModel: FormViewModel {
    var goToDetails: ((StockResponse) -> Void)?
    
    private var state = State()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: - Search Debounce Task
    private var searchTask: Task<Void, Never>?
    
    override init() {
        super.init()
        
        Task { @MainActor in
            self.sections = makeSections()
        }
    }
    
    // MARK: - Fetch
    
    override func fetchData() {
        Task {
            async let stockSuccess = fetchStockItems()
            async let statsSuccess = fetchStatistics()
            
            let (didFetchStock, didFetchStats) = await (stockSuccess, statsSuccess)
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                
                if didFetchStats { self.updateStatsSection() }
                if didFetchStock { self.updateRecentActivitiesSection() }
                
                if !didFetchStock { print("Failed to fetch stock items") }
                if !didFetchStats { print("Failed to fetch statistics") }
            }
        }
    }
    
    // MARK: - Network
    
    @discardableResult
    private func fetchStockItems() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllStock(
                userId: state.userProfile?.sub ?? 0,
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )
            state.items = response.data
            return true
        } catch {
            print("❌ Stock fetch error:", error)
            return false
        }
    }
    
    @discardableResult
    private func fetchStatistics() async -> Bool {
        do {
            let stats = try await bookKeepingService.getOrderSummary(
                userId: state.userProfile?.sub ?? 0,
                accessToken: state.oauthToken
            )
            state.statistics = stats
            return true
        } catch {
            print("❌ Stats fetch error:", error)
            return false
        }
    }
    
    // MARK: - Sections
    
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.search.rawValue,
                cells: [
                    searchRow,
                    SpacerFormRow(tag: 0000),
                    makeStatsRow()
                ]
            ),
            FormSection(
                id: Tags.Section.recentActivities.rawValue,
                cells: makeTransactionActionRows()
            )
        ]
    }
    
    // MARK: - Section Updates
    
    private func updateStatsSection() {
        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == Tags.Section.search.rawValue
        }) else { return }
        
        // Only replace stats row (index 2)
        sections[sectionIndex].cells[2] = makeStatsRow()
        reloadRow(at: IndexPath(row: 2, section: sectionIndex))
    }
    
    private func updateRecentActivitiesSection() {
        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == Tags.Section.recentActivities.rawValue
        }) else { return }
        
        sections[sectionIndex].cells = makeTransactionActionRows()
        reloadSection(sectionIndex)
    }
    
    // MARK: - Search
    
    private func handleSearchInput(_ text: String) {
        state.searchQuery = text
        
        // Keep row model in sync (CRITICAL FIX)
        searchRow.model.text = text
        
        debounceSearch()
    }
    
    private func debounceSearch() {
        searchTask?.cancel()
        
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000)
            await MainActor.run {
                self?.updateRecentActivitiesSection()
            }
        }
    }
    
    private var filteredItems: [StockResponse] {
        let query = state.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return state.items }
        
        return state.items.filter {
            let name = $0.name ?? ""
            return name.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Rows
    
    private lazy var searchRow: SearchFormRow = {
        SearchFormRow(
            tag: Tags.Cells.search.rawValue,
            model: SearchFormModel(
                placeholder: "Search",
                text: state.searchQuery, // persist value
                keyboardType: .default,
                searchIcon: UIImage(systemName: "magnifyingglass"),
                searchIconPlacement: .right,
                filterIcon: nil,
                didTapSearchIcon: { [weak self] in
                    self?.updateRecentActivitiesSection()
                },
                didTapFilterIcon: {
                    print("⚙️ Filter tapped")
                },
                onTextChanged: { [weak self] text in
                    self?.handleSearchInput(text)
                }
            )
        )
    }()
    
    private func makeStatsRow() -> FormRow {
        let stats = state.statistics
        
        let productCount = stats?.productCount ?? 0
        let orderCount = stats?.orderCount ?? 0
        let rating = stats?.averageRating ?? 0
        
        return StatsCardRow(
            tag: 100,
            config: StatsCardConfig(
                items: [
                    .init(
                        id: "products",
                        icon: UIImage(systemName: "archivebox"),
                        title: "Total Products",
                        value: "\(productCount)",
                        iconBackgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                        onTap: { print("Products tapped") }
                    ),
                    .init(
                        id: "orders",
                        icon: UIImage(systemName: "bag"),
                        title: "Total Orders",
                        value: "\(orderCount)",
                        iconBackgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                        onTap: { print("Orders tapped") }
                    ),
                    .init(
                        id: "rating",
                        icon: UIImage(systemName: "star"),
                        title: "Rating",
                        value: String(format: "%.1f", rating),
                        iconBackgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                        onTap: { print("Rating tapped") }
                    )
                ]
            )
        )
    }
    
    private func makeTransactionActionRows() -> [FormRow] {
        filteredItems.enumerated().map { index, item in
            
            let isInStock = item.inStock ?? false
            let unit = item.measurementUnit?.name ?? ""
            let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
            
            let config = TransactionActionsCellConfig(
                title: item.name ?? "name",
                subtitle: "\(item.minimumOrderQuantity) \(unit) available",
                amount: "\(currency) \(Int(item.price ?? 0.0))",
                amountColor: .label,
                status: isInStock ? "In Stock" : "Out of Stock",
                statusColor: isInStock ? .systemGreen : .systemRed,
                
                primaryAction: ActionCardConfig(
                    title: "View details",
                    icon: UIImage(systemName: "eye"),
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    textColor: .app(.hex("#656C7A")),
                    onTap: { [weak self] in
                        self?.goToDetails?(item)
                    }
                ),
                
                secondaryAction: InlineActionConfig(
                    title: "Edit",
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit tapped for \(item.name)")
                    }
                )
            )
            
            return TransactionActionsRow(tag: index, config: config)
        }
    }
    
    // MARK: - State
    
    private struct State {
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userProfile
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var items: [StockResponse] = []
        var statistics: StatisticsResponse?
        var searchQuery: String = ""
    }
    
    // MARK: - Tags
    
    enum Tags {
        enum Section: Int {
            case search = 0
            case recentActivities = 1
        }
        
        enum Cells: Int {
            case search = 0
        }
    }
}
