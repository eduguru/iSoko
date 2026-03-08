//
//  BookKeepingReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingReportsViewModel: FormViewModel {

    // MARK: - Navigation Callbacks
    var gotoConfirm: ((ReportSelectionPayload) -> Void)? = { _ in }
    var onStartDateTap: (() -> Void)?
    var onEndDateTap: (() -> Void)?
    var onCustomTimeframeTap: (() -> Void)?

    // MARK: - Available Timeframes
    private let availableTimeframes: [Timeframe] = [
        .today,
        .yesterday,
        .last7Days,
        .last30Days,
        .lastMonth,
        .last3Months,
        .last6Months,
        .thisMonth,
        .custom
    ]

    // MARK: - Internal State
    private var state = State()

    // MARK: - Init
    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            makeSelectionSection(),
            makeSpacerSection(),
            makeTimeFrameSection(),
            makeActionSection()
        ]
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(
            id: SectionTag.selection.rawValue,
            cells: [
                titleDescriptionFormRow,
                selectionInputRow
            ]
        )
    }

    private func makeSpacerSection() -> FormSection {
        FormSection(
            id: SectionTag.spacer.rawValue,
            cells: [
                SpacerFormRow(tag: 20)
            ]
        )
    }

    private func makeTimeFrameSection() -> FormSection {
        FormSection(
            id: SectionTag.timeFrame.rawValue,
            title: "Select Time Frame",
            cells: [
                timeFrameRow,
                filterFormRow
            ]
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

    // MARK: - Rows

    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow()
    private lazy var selectionInputRow: FormRow = makeSelectionGrid()
    private lazy var timeFrameRow: FormRow = makeTimeFrameGrid()
    private lazy var filterFormRow: FormRow = makeFilterFormRow()

    private func makeTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: CellTag.reportTitle.rawValue,
            title: "Select Report Type",
            description: "Choose a report to view your business performance",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .subheadline,
            descriptionFontStyle: .body
        )
    }

    private func makeSelectionGrid() -> FormRow {

        SelectableCardGridRow(
            tag: CellTag.category.rawValue,
            config: .init(
                items: [
                    .init(title: "Sales", subtitle: "Track revenue", icon: UIImage(systemName:"chart.line.uptrend.xyaxis"), onTap: { [weak self] _ in self?.state.selectedReport = .sales }),
                    .init(title: "Expenses", subtitle: "Monitor spending", icon: UIImage(systemName:"calendar"), onTap: { [weak self] _ in self?.state.selectedReport = .expenses }),
                    .init(title: "Stock", subtitle: "Inventory levels", icon: UIImage(systemName:"archivebox"), onTap: { [weak self] _ in self?.state.selectedReport = .stock }),
                    .init(title: "Profit & Loss", subtitle: "Financial performance", icon: UIImage(systemName:"chart.bar"), onTap: { [weak self] _ in self?.state.selectedReport = .profitLoss }),
                    .init(title: "Customers", subtitle: "Top buyers", icon: UIImage(systemName:"person.2"), onTap: { [weak self] _ in self?.state.selectedReport = .customers }),
                    .init(title: "Suppliers", subtitle: "Vendors", icon: UIImage(systemName:"truck.box"), onTap: { [weak self] _ in self?.state.selectedReport = .suppliers })
                ],
                allowsMultipleSelection: false
            )
        )
    }

    private func makeTimeFrameGrid() -> FormRow {

        let timeframeOptions = availableTimeframes.map {
            TimeframeOption(title: $0.title)
        }

        let config = TimeframeSelectorConfig(
            options: timeframeOptions,
            allowsMultipleSelection: false,
            selectedIndex: 0
        )

        let row = TimeframeSelectorRow(
            tag: 101,
            config: config
        )

        row.onSelectionChanged = { [weak self] index in
            guard let self else { return }

            let timeframe = self.availableTimeframes[index]
            self.state.timeframe = timeframe

            let range = DateFormatters.dateRange(for: timeframe)
            self.state.startDate = range.start
            self.state.endDate = range.end
        }

        row.onCustomSelected = { [weak self] in
            self?.state.timeframe = .custom
            self?.onCustomTimeframeTap?()
        }

        return row
    }

    private func makeFilterFormRow() -> FormRow {

        let row = FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "Custom Range",
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Start Date",
                            selectedValue: nil,
                            iconSystemName: "calendar",
                            onTap: { [weak self] in
                                self?.onStartDateTap?()
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "End Date",
                            selectedValue: nil,
                            iconSystemName: "calendar",
                            onTap: { [weak self] in
                                self?.onEndDateTap?()
                            }
                        )
                    ]
                ],
                message: ""
            )
        )

        return row
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

    // MARK: - Submit
    @MainActor
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

    // MARK: - Enums
    private enum SectionTag: Int {
        case selection = 0
        case spacer
        case timeFrame
        case action
    }

    private enum CellTag: Int {
        case reportTitle = 1
        case category = 4
        case continueButton = 9
    }
}
