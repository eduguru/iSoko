//
//  SalesReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import UIKit
import DesignSystemKit
import UtilsKit
import StorageKit

// MARK: - Sales Report VM
final class SalesReportsViewModel: FormViewModel {
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
        state = State()
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            makeTitleSection(),
            makeFilterSection(),
            makeRecentActivitiesSection(),
            makeActionSection()
        ]
    }

    private func makeFilterSection() -> FormSection {
        FormSection(
            id: SectionTag.filterSection.rawValue,
            cells: [filterFormRow]
        )
    }
    
    private func makeTitleSection() -> FormSection {
        FormSection(
            id: SectionTag.action.rawValue,
            cells: [
                titleDescriptionFormRow
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
    
    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(title: "Sales Report", description: "Track your revenue performance")
    private lazy var filterFormRow: FormRow = makeFilterFormRow()
    
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
    
    private func makeFilterFormRow() -> FormRow {
        let row = FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: nil,
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Sales Type",
                            selectedValue: nil,
                            onTap: {
                                print("tapped")
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Product",
                            selectedValue: nil,
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "Payment Method",
                            selectedValue: nil,
                            onTap: {
                                print("Time Period tapped")
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Start Date",
                            selectedValue: nil,
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "End Date",
                            selectedValue: nil,
                            onTap: {
                                print("Time Period tapped")
                            }
                        )
                    ]
                    
                ],
                message: ""
            )
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
                saleTypeTextColor: .app(.hex("#35A458")),
                saleTypeBackgroundColor: .app(.hex("#F0FFE5")),
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
                saleTypeTextColor: .app(.hex("#CA391C")),
                saleTypeBackgroundColor: .app(.hex("#FFE5E5")),
                itemsCountText: "2 items",
                primaryAction: ActionCardConfig(
                    title: "View Details",
                    icon: UIImage(systemName: "creditcard"),
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
    
    // MARK: - State
    private struct State {

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var selectedReport: ReportType?
        var timeframe: Timeframe = .today
        var startDate: Date?
        var endDate: Date?

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }
    
    // MARK: - Enums
    private enum SectionTag: Int {
        case title = 0
        case filterSection
        case recentActivities
        
        case action
    }

    private enum CellTag: Int {
        case reportTitle = 0
        case continueButton = 1
    }
}
