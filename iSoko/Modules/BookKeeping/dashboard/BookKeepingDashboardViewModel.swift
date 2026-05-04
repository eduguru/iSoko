//
//  BookKeepingDashboardViewModel.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class BookKeepingDashboardViewModel: FormViewModel {
    
    // MARK: - Navigation
    var goToDetails: (() -> Void)? = { }
    var goToFilter: (() -> Void)? = { }
    
    var goToTotalSales: (() -> Void)? = { }
    var goToTotalProducts: (() -> Void)? = { }
    var goToTotalExpense: (() -> Void)? = { }
    var goToLowStock: (() -> Void)? = { }
    
    var goToRecordSales: (() -> Void)? = { }
    var goToAddExpense: (() -> Void)? = { }
    
    var goToManageStock: (() -> Void)? = { }
    var goToViewReports: (() -> Void)? = { }
    
    var goToCustomers: (() -> Void)? = { }
    var goToSuppliers: (() -> Void)? = { }
    
    // MARK: - State
    private var state = State()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: - Init
    override init() {
        super.init()
        
        Task { @MainActor in
            self.sections = makeSections()
        }
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await performNetworkRequest()
            
            if !success {
                print("Failed to fetch dashboard data")
            }
            
            await MainActor.run { [weak self] in
                self?.updateFinancialSummarySection()
                self?.updateRecentActivitiesSection()
            }
        }
    }
    
    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllReportsByDate(
                startDate: state.startDate,
                endDate: state.endDate,
                accessToken: state.oauthToken
            )
            
            self.state.summary = response
            return true
            
        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    // MARK: - Section Updates
    private func updateFinancialSummarySection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.financialSummary.rawValue
        }) else { return }
        
        sections[index].cells = makeFinancialRows()
        reloadSection(index)
    }
    
    private func updateRecentActivitiesSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.recentActivities.rawValue
        }) else { return }
        
        sections[index].cells = makeRecentActivitiesRows()
        reloadSection(index)
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            makeFilterSection(),
            makeFinancialSummarySection(),
            makeQuickActionsSection(),
            makeBusinessMetricsSection(),
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
            cells: makeFinancialRows()
        )
    }
    
    private func makeQuickActionsSection() -> FormSection {
        FormSection(
            id: Tags.Section.quickActions.rawValue,
            cells: [quickActionsRow, quickActionsNoTitleRow]
        )
    }
    
    private func makeBusinessMetricsSection() -> FormSection {
        FormSection(
            id: Tags.Section.businessMetrics.rawValue,
            cells: [businessMetricsRow]
        )
    }
    
    private func makeRecentActivitiesSection() -> FormSection {
        FormSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: makeRecentActivitiesRows()
        )
    }
    
    // MARK: - Financial Mapping
    private func makeFinancialRows() -> [FormRow] {
        
        let summary = state.summary
        
        let revenue = summary?.totalRevenue ?? 0
        let expenses = summary?.totalExpenses ?? 0
        let products = summary?.totalProducts ?? 0
        let lowStock = summary?.lowStock ?? 0
        
        let row1 = DualCardFormRow(
            tag: 100,
            config: DualCardCellConfig(
                left: makeFinancialItem(
                    title: "Total Sales",
                    value: formatCurrency(revenue),
                    color: .systemGreen,
                    icon: "arrow.up",
                    subtitle: "Revenue",
                    action: goToTotalSales
                ),
                right: makeFinancialItem(
                    title: "Total Expenses",
                    value: formatCurrency(expenses),
                    color: .systemRed,
                    icon: "arrow.down",
                    subtitle: "Spending",
                    action: goToTotalExpense
                )
            )
        )
        
        let row2 = DualCardFormRow(
            tag: 101,
            config: DualCardCellConfig(
                left: makeFinancialItem(
                    title: "Total Products",
                    value: "\(products)",
                    color: .systemBlue,
                    icon: "cube.box",
                    subtitle: "Inventory",
                    action: goToTotalProducts
                ),
                right: makeFinancialItem(
                    title: "Low Stock",
                    value: "\(lowStock)",
                    color: .systemOrange,
                    icon: "exclamationmark.triangle",
                    subtitle: lowStock > 0 ? "Needs attention" : "All good",
                    action: goToLowStock
                )
            )
        )
        
        return [row1, row2]
    }
    
    private func makeFinancialItem(
        title: String,
        value: String,
        color: UIColor,
        icon: String,
        subtitle: String,
        action: (() -> Void)?
    ) -> DualCardItemConfig {
        DualCardItemConfig(
            title: title,
            titleIcon: UIImage(systemName: "chart.bar"),
            subtitle: value,
            status: CardStatusStyle(
                text: subtitle,
                textColor: color,
                backgroundColor: color.withAlphaComponent(0.15),
                icon: UIImage(systemName: icon)
            ),
            onTap: action
        )
    }
    
    // MARK: - Recent Activities
    private func makeRecentActivitiesRows() -> [FormRow] {
        let activities = state.summary?.recentActivity ?? []
        
        return activities.enumerated().map { index, activity in
            
            let title = activity.summary ?? "Activity"
            let amount = formatAmount(activity.value ?? "", type: activity.entityType)
            let isPositive = isPositive(activity.entityType)
            
            let config = TransactionCellConfig(
                image: icon(for: activity.entityType),
                imageSize: .init(width: 36, height: 36),
                imageStyle: .init(
                    shape: .circle,
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    inset: 6
                ),
                title: title,
                description: activity.action,
                amount: amount,
                amountColor: isPositive ? .systemGreen : .systemRed,
                spacing: 12,
                contentInsets: .init(top: 12, left: 16, bottom: 12, right: 16),
                onTap: { [weak self] in
                    self?.goToDetails?()
                },
                isCardStyleEnabled: true,
                cardCornerRadius: 12,
                cardBackgroundColor: .systemBackground,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1
            )
            
            return TransactionRow(tag: index, config: config)
        }
    }
    
    // MARK: - Helpers
    
    private func formatCurrency(_ value: Double) -> String {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        
        return "\(currency). \(Int(value))"
    }
    
    private func formatAmount(_ value: String, type: String?) -> String {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        
        guard let number = Double(value),
              type == "sale" || type == "expense" else {
            return value
        }
        return "\(currency). \(Int(number))"
    }
    
    private func isPositive(_ type: String?) -> Bool {
        type == "sale"
    }
    
    private func icon(for type: String?) -> UIImage? {
        switch type {
        case "sale": return UIImage(systemName: "arrow.up.circle")
        case "expense": return UIImage(systemName: "arrow.down.circle")
        case "product": return UIImage(systemName: "cube.box")
        case "customer": return UIImage(systemName: "person")
        case "supplier": return UIImage(systemName: "truck")
        default: return UIImage(systemName: "clock")
        }
    }
    
    // MARK: - Rows
    private lazy var filterRow: FormRow = makeFilterRowRow()
    private lazy var quickActionsRow: FormRow = makeQuickActionsRow()
    private lazy var quickActionsNoTitleRow: FormRow = makeQuickNoTitleActionsRow()
    private lazy var businessMetricsRow: FormRow = makeBusinessMetricsRow()
    
    private func makeFilterRowRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Financial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .white,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: { [weak self] in self?.goToFilter?() }
        )
        
        return TitleDropDownFilterFormRow(
            tag: Tags.Cells.filter.rawValue,
            model: model
        )
    }
    
    
    
    private func makeQuickActionsRow() -> FormRow {
        
        let sale = StatusCardViewModel(
            title: "Record Sale",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#22C55E")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56,
            onTapAction: { [weak self] in
                self?.goToRecordSales?()
            }
        )
        
        let expense = StatusCardViewModel(
            title: "Add Expense",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#EF4444")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80,
            onTapAction: { [weak self] in
                self?.goToAddExpense?()
            }
        )
        
        return TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                title: "Quick Actions",
                description: "Common bookkeeping tasks",
                cards: TwoStatusCardsViewModel(
                    first: sale,
                    second: expense,
                    layout: .horizontal
                )
            )
        )
    }
    
    private func makeQuickNoTitleActionsRow() -> FormRow {
        
        let stock = StatusCardViewModel(
            title: "Manage Stock",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#3B82F6")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56,
            onTapAction: { [weak self] in
                self?.goToManageStock?()
            }
        )
        
        let reports = StatusCardViewModel(
            title: "View Reports",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#6366F1")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80,
            onTapAction: { [weak self] in
                self?.goToViewReports?()
            }
        )
        
        return TwoStatusCardsFormRow(
            tag: 201,
            model: TwoStatusCardsViewModel(
                first: stock,
                second: reports,
                layout: .horizontal
            )
        )
    }
    
    private func makeBusinessMetricsRow() -> FormRow {
        
        let customers = StatusCardViewModel(
            title: "Customers",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#A855F7")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56,
            onTapAction: { [weak self] in
                self?.goToCustomers?()
            }
        )
        
        let suppliers = StatusCardViewModel(
            title: "Suppliers",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .app(.hex("#14B8A6")),
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80,
            onTapAction: { [weak self] in
                self?.goToSuppliers?()
            }
        )
        
        return TwoCardsSummaryFormRow(
            tag: 202,
            model: TwoCardsSummaryViewModel(
                title: "Business Management",
                description: "Manage customers and suppliers",
                cards: TwoStatusCardsViewModel(
                    first: customers,
                    second: suppliers,
                    layout: .horizontal
                )
            )
        )
    }
    
    // MARK: - State
    private struct State {
        var summary: BookKeepingSummaryResponse?
        var startDate: String = "2025-01-01"
        var endDate: String = "2027-01-01"
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
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
