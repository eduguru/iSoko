//
//  StockReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import UIKit
import DesignSystemKit
import UtilsKit
import StorageKit

// MARK: - Stock Report VM
final class StockReportsViewModel: FormViewModel {
    
    var goToDetails: (() -> Void)?
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void)
    -> Void = { _, _, _ in }
    
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    var gotoSelectSystemCountry: (CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) -> Void = { _, _ in }

    var gotoConfirm: (() -> Void)?
    var goToAddCategory: (() -> Void)? = { }
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: -
    private var state: State
    
    init(payload: ReportSelectionPayload) {
        state = State(payload: payload)
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            makeTitleSection(),
            makeFilterSection(),
            makeSelectionSection(),
            makeRecentActivitiesSection(),
            // makeActionSection()
        ]
    }
    
    private func makeTitleSection() -> FormSection {
        FormSection(
            id: SectionTag.action.rawValue,
            cells: [
                titleDescriptionFormRow
            ]
        )
    }
    
    private func makeFilterSection() -> FormSection {
        FormSection(
            id: SectionTag.filter.rawValue,
            cells: [filterFormRow]
        )
    }
    
    private func makeSelectionSection() -> FormSection {
        FormSection(
            id: SectionTag.selection.rawValue,
            cells: [
                selectionInputRow
            ]
        )
    }
    
    private func makeRecentActivitiesSection() -> FormSection {
        FormSection(
            id: SectionTag.recentActivities.rawValue,
            cells: makeTransactionActionRows()
        )
    }
    
    private func makeActionSection() -> FormSection {
        FormSection(
            id: SectionTag.action.rawValue,
            cells: [
                continueButtonRow
            ]
        )
    }
    
    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: CellTag.reportTitle.rawValue,
            model: TitleDescriptionModel(
            title: title,
            description:description,
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .subheadline,
            descriptionFontStyle: .body
            )
        )
    }
    

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task {
                await self?.submit()
            }
        }
    )
    
    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(title: "Stock Report", description: "Inventory levels overview")
    private lazy var filterFormRow: FormRow = makeFilterFormRow()
    
    private lazy var selectionInputRow: FormRow = makeSelectionGrid()
    
    private func makeFilterFormRow() -> FormRow {

        let row = FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: nil,
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Supplier",
                            selectedValue: nil,
                            iconSystemName: "mappin.and.ellipse",
                            onTap: { [weak self] in
                                self?.handleSupplierSelection()
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Start Date",
                            selectedValue: self.state.startDate?.getYearMonthDay(),
                            iconSystemName: "tag",
                            onTap: { [weak self] in
                                self?.handleStartDateSelection()
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "End Date",
                            selectedValue: self.state.endDate?.getYearMonthDay(),
                            iconSystemName: "calendar",
                            onTap: { [weak self] in
                                self?.handleEndDateSelection()
                            }
                        )
                    ]
                ],
                message: ""
            )
        )

        return row
    }
    
    private func makeSelectionGrid() -> FormRow {

        let summary = state.stockSummary

        let items: [SelectableCardItemConfig] = [
            .init(
                title: "Available Stock",
                subtitle: "\(summary?.availableStock ?? 0)",
                icon: UIImage(systemName:"cube.box"),
                iconTintColor: .systemBlue,
                selectionColor: .clear,
                selectionImage: nil,
                showsSelection: false,
                onTap: { [weak self] _ in
                    self?.state.selectedReport = .sales
                }
            ),
            .init(
                title: "Stock Value",
                subtitle: "Ksh \(summary?.value ?? 0)",
                icon: UIImage(systemName:"banknote"),
                iconTintColor: .systemBlue,
                selectionColor: .clear,
                selectionImage: nil,
                showsSelection: false,
                onTap: { [weak self] _ in
                    self?.state.selectedReport = .sales
                }
            ),
            .init(
                title: "Profit",
                subtitle: "Ksh \(summary?.profit ?? 0)",
                icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                iconTintColor: .systemBlue,
                selectionColor: .clear,
                selectionImage: nil,
                showsSelection: false,
                onTap: { [weak self] _ in
                    self?.state.selectedReport = .sales
                }
            ),
            .init(
                title: "Low Stock",
                subtitle: "\(summary?.lowStock ?? 0)",
                icon: UIImage(systemName:"exclamationmark.triangle"),
                iconTintColor: .systemBlue,
                selectionColor: .clear,
                selectionImage: nil,
                showsSelection: false,
                onTap: { [weak self] _ in
                    self?.state.selectedReport = .sales
                }
            ),
            .init(
                title: "Stock Intake",
                subtitle: "\(summary?.stockIntake ?? 0)",
                icon: UIImage(systemName:"arrow.down.circle"),
                iconTintColor: .systemBlue,
                selectionColor: .clear,
                selectionImage: nil,
                showsSelection: false,
                onTap: { [weak self] _ in
                    self?.state.selectedReport = .sales
                }
            ),
            .init(
                title: "Out of Stock",
                subtitle: "\(summary?.outOfStock ?? 0)",
                icon: UIImage(systemName:"xmark.octagon"),
                iconTintColor: .systemBlue,
                selectionColor: .clear,
                selectionImage: nil,
                showsSelection: false,
                onTap: { [weak self] _ in
                    self?.state.selectedReport = .sales
                }
            )
        ]

        return SelectableCardGridRow(
            tag: CellTag.category.rawValue,
            config: .init(
                items: items,
                allowsMultipleSelection: false
            )
        )
    }
    
    // Lazy factory that creates rows
    private func makeTransactionActionRows() -> [FormRow] {
        state.stockHistory.map { item in

            let qty = item.quantity ?? 0
            let price = item.price ?? 0

            let config = TransactionActionsCellConfig(
                title: item.name ?? "Item",
                subtitle: "\(qty) units",
                amount: "Ksh. \(price)",
                amountColor: .label,
                status: "",
                statusColor: .app(.hex("#717171")),
                primaryAction: ActionCardConfig(
                    title: "View details",
                    icon: UIImage(systemName: "eye"),
                    backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                    textColor: .app(.hex("#656C7A")),
                    onTap: {
                        print("View tapped for \(item.id ?? 0)")
                    }
                ),
                secondaryAction: InlineActionConfig(
                    title: "Edit",
                    icon: UIImage(systemName: "pencil"),
                    onTap: {
                        print("Edit tapped for \(item.id ?? 0)")
                    }
                )
            )

            return TransactionActionsRow(
                tag: item.id ?? UUID().hashValue,
                config: config
            )
        }
    }
    
    // MARK: - Submit
    private func submit() async {

        guard let report = state.selectedReport else {
            print("No report selected")
            return
        }

        let payload = ReportSelectionPayload(
            report: report,
            timeframe: state.timeframe,
            startDate: state.startDate,
            endDate: state.endDate
        )

        gotoConfirm?()
    }
    
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getAllStockReportByDate(
                startDate: state.payload.startDate?.getYearMonthDay() ?? "",
                endDate: state.payload.endDate?.getYearMonthDay() ?? "",
                accessToken: state.oauthToken
            )

            // ✅ STORE REAL DATA
            state.stockSummary = response
            state.stockHistory = response.stock ?? []

            return true

        } catch {
            print("❌ Stock report error:", error)
            return false
        }
    }
    
    override func fetchData() {
        Task {
            let success = await performNetworkRequest()

            if !success {
                print("Failed to fetch stock report")
            }

            await MainActor.run {
                updateSelectionSection()
                updateRecentActivitiesSection()
                updateFilterSection()
            }
        }
    }
    
    private func updateFilterSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.filter.rawValue
        }) else { return }

        sections[index].cells = [makeFilterFormRow()]
        reloadSection(index)
    }
    
    private func updateRecentActivitiesSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.recentActivities.rawValue
        }) else { return }

        sections[index].cells = makeTransactionActionRows()
        reloadSection(index)
    }
    
    private func updateSelectionSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.selection.rawValue
        }) else { return }

        sections[index].cells = [makeSelectionGrid()]
        reloadSection(index)
    }
    
    private func handleSupplierSelection() {
        goToCommonSelectionOptions(.suppliers(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            // If you later add supplier to state, store it here
            // self.state.selectedSupplier = value

            self.updateFilterSection()
            self.fetchData()
        }
    }
    
    private func handleStartDateSelection() {
        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }

            self.state.startDate = date

            self.updateFilterSection()
            self.fetchData()
        }
    }
    
    private func handleEndDateSelection() {
        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }

            self.state.endDate = date

            self.updateFilterSection()
            self.fetchData()
        }
    }
    
    // MARK: - State
    private struct State {
        var payload: ReportSelectionPayload

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var selectedReport: ReportType?
        var timeframe: Timeframe = .today
        var startDate: Date?
        var endDate: Date?

        // ✅ NEW: API response storage
        var stockSummary: StockReportResponse?
        var stockHistory: [StockReportHistoryResponse] = []

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }
    
    // MARK: - Enums
    private enum SectionTag: Int {
        case title = 0
        case action
        case recentActivities = 4
        case filter
        case selection
        case financialSummary
    }

    private enum CellTag: Int {
        case reportTitle = 0
        case continueButton = 1
        case recentActivities = 4
        case category
    }
}
