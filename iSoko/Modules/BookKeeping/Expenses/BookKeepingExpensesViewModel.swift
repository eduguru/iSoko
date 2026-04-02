//
//  BookKeepingExpensesViewModel.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingExpensesViewModel: FormViewModel {
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
                let response = try await bookKeepingService.getAllExpenses(
                    page: 1,
                    count: 10,
                    accessToken: state.oauthToken
                )
                
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
            cells: [searchRow, filterFormRow]
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
    private lazy var filterFormRow: FormRow = makeFilterFormRow()
    
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
    
    private func makeFilterFormRow() -> FormRow {
        let row = FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "Filters",
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Sale Type",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "Time Period",
                            selectedValue: nil,
                            iconSystemName: "calendar",
                            onTap: {
                                print("Time Period tapped")
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Region",
                            selectedValue: nil,
                            iconSystemName: "mappin.and.ellipse",
                            onTap: {
                                print("Region tapped")
                            }
                        )
                    ]
                ],
                message: "Select filters to refine your results"
            )
        )

        return row
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let config = DualCardCellConfig(
            left: DualCardItemConfig(
                title: "Total Customers",
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
                title: "Active Buyers",
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
   
    func generateTransactionData(from configs: [TransactionSummaryCellConfig]) -> [FormRow] {
        return configs.enumerated().map { index, config in
            // Create a new row for each config
            return TransactionSummaryRow(tag: index, config: config)
        }
    }
    
    private func makeTransactionActionRows() -> [FormRow] {
        // Example of multiple configurations with actions included
        let configs: [TransactionSummaryCellConfig] = [
            TransactionSummaryCellConfig(
                title: "John Doe",
                amount: "Ksh. 12,987",
                amountColor: .green,
                dateText: "Oct 27, 2025",
                saleTypeText: "Cash Sale",
                saleTypeTextColor: .white,
                saleTypeBackgroundColor: .green,
                itemsCountText: "3 items",
                primaryAction: ActionCardConfig(
                    title: "View Details",
                    icon: UIImage(systemName: "eye.fill"),
                    backgroundColor: .white,
                    textColor: .label,
                    borderColor: .systemGray4,
                    borderWidth: 1
                ),
                secondaryAction: InlineActionConfig(
                    title: "Edit",
                    icon: UIImage(systemName: "pencil"),
                    onTap: { print("Edit tapped!") }
                ),
                cardBackgroundColor: .white,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            ),
            TransactionSummaryCellConfig(
                title: "Jane Smith",
                amount: "Ksh. 8,500",
                amountColor: .blue,
                dateText: "Nov 15, 2025",
                saleTypeText: "Credit Sale",
                saleTypeTextColor: .white,
                saleTypeBackgroundColor: .blue,
                itemsCountText: "2 items",
                primaryAction: ActionCardConfig(
                    title: "View Details",
                    icon: UIImage(systemName: "eye.fill"),
                    backgroundColor: .white,
                    textColor: .label,
                    borderColor: .systemGray4,
                    borderWidth: 1
                ),
                secondaryAction: InlineActionConfig(
                    title: "Delete",
                    icon: UIImage(systemName: "trash"),
                    onTap: { print("Delete tapped!") }
                ),
                cardBackgroundColor: .white,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )
        ]

        // Generate rows
        let rows: [FormRow] = generateTransactionData(from: configs)
        return rows

    }

    // MARK: - State
    private struct State {
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


