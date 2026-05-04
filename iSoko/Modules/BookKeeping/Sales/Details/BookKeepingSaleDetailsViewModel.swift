//
//  BookKeepingSaleDetailsViewModel.swift
//
//
//  Created by Edwin Weru on 16/02/2026.
//


import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingSaleDetailsViewModel: FormViewModel {
    var goToDetails: (() -> Void)? = { }
    
    var goToEdit: ((SalesResponse) -> Void)? = { _ in }
    func goToEditAction() {  goToEdit?(state.item) }
    
    private var state: State
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    init(_ item: SalesResponse) {
        state = State(item: item)
        
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
            let response = try await bookKeepingService.getAllStock(
                userId: state.userProfile?.sub ?? 0,
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
            makeProfileSection(),
            makeFinancialSummarySection(),
            makeRecentActivitiesSection()
        ]
    }
    
    private func makeProfileSection() -> FormSection {
        FormSection(
            id: Tags.Section.filter.rawValue,
            cells: [profileRow]
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
    private lazy var  profileRow: FormRow = makeProfileInfoRow()
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private func makeProfileInfoRow() -> FormRow {
        let model = ProfileInfoCellConfig(
            name: state.item.customer?.name ?? "Customer: N/A",  // Default name if customer name is nil
            infoItems: [
                // Using the correct SF Symbols for each piece of info
                makeInfoItem(state.item.customer?.name ?? "Customer: N/A", icon: "person.fill"), // Customer name with person icon
                makeInfoItem(state.item.description ?? "Description: N/A", icon: "doc.text.fill"), // Description or email with a document icon
                makeInfoItem(state.item.paymentMethod?.name ?? "Payment Method: N/A", icon: "creditcard.fill") // Payment method with credit card icon
            ],
            onEditTap: {
                // Handle the edit action here
            }
        )
        
        let row = ProfileInfoRow(tag: Tags.Cells.filter.rawValue, config: model)
        return row
    }
    
    private func makeInfoItem(_ text: String?, icon: String) -> InfoItem {
        InfoItem(text: text, icon: UIImage(systemName: icon))
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Value",
                titleIcon: UIImage(systemName: "chart.bar"),
                subtitle: "0.00",
                status: nil
            ),
            right: DualCardItemConfig(
                title: "Items Supplied",
                titleIcon: UIImage(systemName: "doc.text"),
                subtitle: "0",
                status: nil
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
        return state.items.enumerated().map { index, item in
            
            let isInStock = item.inStock ?? false
            
            // Map images (optional: use first image if needed later)
            let items = [
                OrderItem(
                    quantity: item.minimumOrderQuantity ?? 1,
                    name: item.name ?? "name",
                    amount: "Ksh \(Int(item.price ?? 0.0))"
                )
            ]
            
            let config = OrderSummaryCellConfig(
                orderTitle: item.name ?? "name",
                amount: "Ksh \(Int(item.price ?? 0.0))",
                dateString: item.description ?? "No description",
                itemCountString: "\(items.count) item",
                statusText: isInStock ? "In Stock" : "Out of Stock",
                statusTextColor: isInStock
                    ? UIColor.systemGreen
                    : UIColor.systemRed,
                statusBackgroundColor: isInStock
                    ? UIColor.systemGreen.withAlphaComponent(0.15)
                    : UIColor.systemRed.withAlphaComponent(0.15),
                items: items
            )
            
            return OrderSummaryRow(tag: index, config: config)
        }
    }
    
    // MARK: - State
    private struct State {
        var item: SalesResponse
        
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userProfile
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var items: [StockResponse] = []
    }
    
    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
        }
        enum Cells: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            
        }
    }
}

