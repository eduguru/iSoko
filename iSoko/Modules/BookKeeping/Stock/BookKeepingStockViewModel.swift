//
//  BookKeepingStockViewModel.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class BookKeepingStockViewModel: FormViewModel {
    var goToDetails: ((StockResponse) -> Void)? = { _ in }
    
    private var state = State()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    @MainActor private let countryHelper = CountryHelper()
    
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
            let response = try await bookKeepingService.getAllStock(
                userId: state.userProfile?.sub ?? 0,
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )
            
            state.items = response.data
            state.filteredItems = response.data
            
            return true
            
        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    private func updateRecentActivitiesSection() {
        updateSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: makeTransactionActionRows()
        )
    }
    
    // MARK: - Sections -
    private func makeSections() -> [FormSection] {
        [
            makeFilterSection(),
            makeRecentActivitiesSection()
        ]
    }
    
    private func makeFilterSection() -> FormSection {
        FormSection(
            id: Tags.Section.search.rawValue,
            cells: [searchRow]
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
    private lazy var searchRow = makeSearchRow()
    
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
                    self?.filterItems(text)
                }
            )
        )
    }
    
    private var searchWorkItem: DispatchWorkItem?
    private func filterItems(_ text: String) {

        state.searchText = text

        searchWorkItem?.cancel()

        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }

            let query = text.lowercased()

            self.state.filteredItems = query.isEmpty
                ? self.state.items
                : self.state.items.filter {

                    ($0.name?.lowercased().contains(query) ?? false)

                    || ($0.measurementUnit?.name?.lowercased().contains(query) ?? false)

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
    
    // Lazy factory that creates rows
    private func makeTransactionActionRows() -> [FormRow] {
        return state.filteredItems.enumerated().map { index, item in
            
            let isInStock = item.inStock ?? false
            let unit = item.measurementUnit?.name ?? ""
            
            let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
            
            let config = TransactionActionsCellConfig(
                title: item.name ?? "title",
                subtitle: "\(item.minimumOrderQuantity ?? 0) \(unit) available",
                amount: "\(currency) \(Int(item.price ?? 0.0))",
                amountColor: .label,
                status: isInStock ? "In Stock" : "Out of Stock",
                statusColor: isInStock ? .systemGreen : .systemRed,
                
                primaryAction: ActionCardConfig(
                    title: "common.action.view_details".localized,
                    icon: UIImage(systemName: "eye"),
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    textColor: .app(.hex("#656C7A")),
                    onTap: { [weak self] in
                        self?.goToDetails?(item)
                        print("View details tapped for \(item.name)")
                    }
                ),
                
                secondaryAction: InlineActionConfig(
                    title: "common.action.edit".localized,
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit tapped for \(item.name)")
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
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
                
        var items: [StockResponse] = []              // Original API response
        var filteredItems: [StockResponse] = []      // Displayed in UI

        var searchText = ""
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

