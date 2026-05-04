//
//  MyOrdersViewModel.swift
//  
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class MyOrdersViewModel: FormViewModel {
    var goToDetails: ((CustomerOrderResponse) -> Void)?
    
    private var state = State()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: - Search Debounce Task
    private var searchTask: Task<Void, Never>?
    
    override init() {
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    
    override func fetchData() {
        Task {
            let didFetchOrders = await fetchOrders()
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                if didFetchOrders {
                    self.updateRecentActivitiesSection()
                } else {
                    print("Failed to fetch orders")
                }
            }
        }
    }
    
    // MARK: - Network
    
    @discardableResult
    private func fetchOrders() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllOrders(
                page: 1,
                count: 10,
                traderType: "buyer",
                accessToken: state.oauthToken
            )
            
            state.items = response.data
            return true
            
        } catch {
            print("❌ Orders fetch error:", error)
            return false
        }
    }
    
    // MARK: - Sections
    
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.search.rawValue,
                cells: [searchRow]
            ),
            FormSection(
                id: Tags.Section.recentActivities.rawValue,
                cells: makeTransactionActionRows()
            )
        ]
    }
    
    // MARK: - Section Updates
    
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
    
    private var filteredItems: [CustomerOrderResponse] {
        let query = state.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return state.items }
        
        return state.items.filter {
            $0.orderNumber.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Rows
    
    private lazy var searchRow: SearchFormRow = {
        SearchFormRow(
            tag: Tags.Cells.search.rawValue,
            model: SearchFormModel(
                placeholder: "Search orders",
                text: state.searchQuery,
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
    
    private func makeTransactionActionRows() -> [FormRow] {
        filteredItems.enumerated().map { index, order in
            
            TransactionActionsRow(
                tag: 3000 + index,
                config: TransactionActionsCellConfig(
                    
                    //Clean usage from model
                    title: order.displayTitle,
                    subtitle: order.displaySubtitle,
                    
                    amount: "\(order.amount)",
                    amountColor: .label,
                    
                    status: order.displayStatus,
                    statusColor: order.statusColor,
                    
                    primaryAction: ActionCardConfig(
                        title: "View details",
                        icon: UIImage(systemName: "eye"),
                        backgroundColor: UIColor.systemBlue.withAlphaComponent(0.1),
                        textColor: .app(.primary),
                        onTap: { [weak self] in
                            self?.goToDetails?(order)
                        }
                    ),
                    
                    secondaryAction: InlineActionConfig(
                        title: "Contact",
                        icon: UIImage(systemName: "message"),
                        onTap: {
                            print("Contact tapped for order \(order.orderNumber)")
                        }
                    ),
                    
                    cardBackgroundColor: .systemBackground,
                    cardBorderColor: .systemGray5,
                    cardBorderWidth: 1,
                    cardCornerRadius: 12
                )
            )
        }
    }
    
    // MARK: - State
    
    private struct State {
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userProfile
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var items: [CustomerOrderResponse] = []
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
