//
//  BookKeepingPurchasesViewModel.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingPurchasesViewModel: FormViewModel {
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
            makeFilterSection(),
            makeFinancialSummarySection(),
            makeRecentActivitiesSection()
        ]
    }
    
    private func makeFilterSection() -> FormSection {
        FormSection(
            id: Tags.Section.filter.rawValue,
            cells: [filterRow]
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
    private lazy var  filterRow: FormRow = makeFilterRowRow()
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    
    private func makeFilterRowRow() -> FormRow {
        let model = ProfileInfoCellConfig(
            name: "String",
            phone: "String",
            email: "String",
            location: "String",
            onEditTap: {
            }
        )
        
        let row = ProfileInfoRow(tag: Tags.Cells.filter.rawValue, config: model)
        return row
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Spending",
                titleIcon: UIImage(systemName: "chart.bar"),
                subtitle: "This month",
                status: CardStatusStyle(
                    text: "On track",
                    textColor: .systemGreen,
                    backgroundColor: UIColor.systemGreen.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "checkmark")
                )
            ),
            right: DualCardItemConfig(
                title: "Bills",
                titleIcon: UIImage(systemName: "doc.text"),
                subtitle: "2 due soon",
                status: CardStatusStyle(
                    text: "Action needed",
                    textColor: .systemOrange,
                    backgroundColor: UIColor.systemOrange.withAlphaComponent(0.15),
                    icon: UIImage(systemName: "exclamationmark.triangle")
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
        return state.items.enumerated().map { index, item in
            
            let isInStock = item.inStock
            
            // Map images (optional: use first image if needed later)
            let items = [
                OrderItem(
                    quantity: item.minimumOrderQuantity,
                    name: item.name,
                    amount: "Ksh \(Int(item.price))"
                )
            ]
            
            let config = OrderSummaryCellConfig(
                orderTitle: item.name,
                amount: "Ksh \(Int(item.price))",
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

