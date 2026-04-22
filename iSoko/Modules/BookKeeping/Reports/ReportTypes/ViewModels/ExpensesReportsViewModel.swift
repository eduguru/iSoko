//
//  ExpensesReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import UIKit
import DesignSystemKit
import UtilsKit
import StorageKit
    
final class ExpensesReportsViewModel: FormViewModel {
    var gotoConfirm: ((ReportSelectionPayload) -> Void)?
    var onStartDateTap: (() -> Void)?
    var onEndDateTap: (() -> Void)?
    var onCustomTimeframeTap: (() -> Void)?
    var goToDetails: (() -> Void)? = { }
    
    private var state = State()
    
    override init() {
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Sections -
    private func makeSections() -> [FormSection] {
        [
            makeTitleSection(),
            makeFilterSection(),
            makeFinancialSummarySection(),
            makeRecentActivitiesSection(),
            makeActionSection()
        ]
    }

    private func makeFilterSection() -> FormSection {
        FormSection(
            id: Tags.Section.search.rawValue,
            cells: [filterFormRow]
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
    
    private func makeTitleSection() -> FormSection {
        FormSection(
            id: Tags.Section.action.rawValue,
            cells: [
                titleDescriptionFormRow
            ]
        )
    }
    
    private func makeActionSection() -> FormSection {
        FormSection(
            id: Tags.Section.action.rawValue,
            cells: [
                continueButtonRow
            ]
        )
    }
    
    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.reportTitle.rawValue,
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
        tag: Tags.Cells.continueButton.rawValue,
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

    // MARK: - Lazy Rows
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    private lazy var filterFormRow: FormRow = makeFilterFormRow()
    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(title: "Expenses Report", description: "Monitor your spending")
    
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
                title: nil,
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Category",
                            selectedValue: nil,
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "PaymentMethod",
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

        gotoConfirm?(payload)
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

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case search = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            case action
        }
        enum Cells: Int {
            case search = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            
            case reportTitle
            case continueButton
            
        }
    }
}
