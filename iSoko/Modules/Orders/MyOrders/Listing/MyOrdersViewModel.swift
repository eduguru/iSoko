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

            let firstProduct = order.products?.first

            let statusStyle = makeStatusStyle(for: order.status)

            let actions: [ActionButtonConfig] = {

                switch order.status.lowercased() {

                case "pending":

                    return [

                        ActionButtonConfig(
                            title: "Confirm",
                            style: .subtle,
                            backgroundColor: UIColor.systemGreen.withAlphaComponent(0.12),
                            textColor: .systemGreen,
                            onTap: { [weak self] in
                                self?.confirmOrder(order)
                            }
                        ),

                        ActionButtonConfig(
                            title: "Reject",
                            style: .outlined,
                            textColor: .systemOrange,
                            borderColor: .systemOrange,
                            onTap: { [weak self] in
                                self?.rejectOrder(order)
                            }
                        )
                    ]

                default:

                    return [

                        ActionButtonConfig(
                            title: "View Details",
                            style: .subtle,
                            backgroundColor: UIColor.systemGray5,
                            textColor: .systemGreen,
                            onTap: { [weak self] in
                                self?.goToDetails?(order)
                            }
                        )
                    ]
                }
            }()

            return OrderItemFormRow(

                tag: 5000 + index,

                config: OrderItemCellConfig(

                    customerName: order.buyerFullName,

                    orderNumber: "#\(order.orderNumber)",

                    date: order.formattedDate,

                    status: order.displayStatus,

                    statusTextColor: statusStyle.textColor,

                    statusBorderColor: statusStyle.borderColor,

                    statusBackgroundColor: statusStyle.backgroundColor,

                    amount: "KES \(order.amount)",

                    amountColor: .systemGreen,

                    productImage: UIImage(named: "placeholder-product"),

                    productName: firstProduct?.name ?? "Unknown Product",

                    productQuantityText:
                        "\(firstProduct?.quantity ?? 0) x KES \(firstProduct?.price ?? 0)",

                    productAmount: "KES \(order.amount)",

                    actions: actions
                )
            )
        }
    }
    
    private func makeStatusStyle(
        for status: String
    ) -> (
        textColor: UIColor,
        borderColor: UIColor,
        backgroundColor: UIColor
    ) {

        switch status.lowercased() {

        case "pending":

            return (
                textColor: .systemOrange,
                borderColor: UIColor.systemOrange.withAlphaComponent(0.35),
                backgroundColor: UIColor.systemOrange.withAlphaComponent(0.08)
            )

        case "completed", "delivered":

            return (
                textColor: .systemGreen,
                borderColor: UIColor.systemGreen.withAlphaComponent(0.35),
                backgroundColor: UIColor.systemGreen.withAlphaComponent(0.08)
            )

        case "rejected", "cancelled", "failed":

            return (
                textColor: .systemRed,
                borderColor: UIColor.systemRed.withAlphaComponent(0.35),
                backgroundColor: UIColor.systemRed.withAlphaComponent(0.08)
            )

        default:

            return (
                textColor: .systemBlue,
                borderColor: UIColor.systemBlue.withAlphaComponent(0.35),
                backgroundColor: UIColor.systemBlue.withAlphaComponent(0.08)
            )
        }
    }
    
    private func confirmOrder(_ order: CustomerOrderResponse) {
        print("Confirm order \(order.orderNumber)")
    }

    private func rejectOrder(_ order: CustomerOrderResponse) {
        print("Reject order \(order.orderNumber)")
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
