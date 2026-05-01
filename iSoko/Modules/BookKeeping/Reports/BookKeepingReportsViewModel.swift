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

    // MARK: - Navigation
    var gotoConfirm: ((ReportSelectionPayload) -> Void)? = { _ in }
    var onStartDateTap: (() -> Void)?
    var onEndDateTap: (() -> Void)?
    var onCustomTimeframeTap: (() -> Void)?

    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }

    // MARK: - Timeframes
    private let availableTimeframes: [Timeframe] = [
        .today, .yesterday, .last7Days, .last30Days,
        .lastMonth, .last3Months, .last6Months,
        .thisMonth, .custom
    ]

    private var state = State()

    // MARK: - Init
    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Sections
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
            cells: [makeTitleRow(), makeSelectionGrid()]
        )
    }

    private func makeSpacerSection() -> FormSection {
        FormSection(
            id: SectionTag.spacer.rawValue,
            cells: [SpacerFormRow(tag: 20)]
        )
    }

    private func makeTimeFrameSection() -> FormSection {
        FormSection(
            id: SectionTag.timeFrame.rawValue,
            title: "Select Time Frame",
            cells: makeTimeFrameCells()
        )
    }

    private func makeActionSection() -> FormSection {
        FormSection(
            id: SectionTag.action.rawValue,
            cells: [continueButtonRow]
        )
    }

    // MARK: - CORE IDEA (single source of truth)
    private func makeTimeFrameCells() -> [FormRow] {

        let selector = timeFrameRow

        guard state.timeframe == .custom else {
            return [selector]
        }

        return [
            selector,
            makeFilterFormRow()
        ]
    }

    // MARK: - ROWS
    private lazy var timeFrameRow = makeTimeFrameGrid()

    private func makeTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: CellTag.reportTitle.rawValue,
            model: TitleDescriptionModel(
                title: "Select Report Type",
                description: "Choose a report to view performance",
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .subheadline,
                descriptionFontStyle: .body
            )
        )
    }

    private func makeSelectionGrid() -> FormRow {
        SelectableCardGridRow(
            tag: CellTag.category.rawValue,
            config: .init(
                items: [
                    .init(title: "Sales", subtitle: "Track revenue", icon: UIImage(systemName:"chart.line.uptrend.xyaxis"), onTap: { [weak self] _ in self?.state.selectedReport = .sales }),
                    .init(title: "Expenses", subtitle: "Monitor spending", icon: UIImage(systemName:"calendar"), onTap: { [weak self] _ in self?.state.selectedReport = .expenses }),
                    .init(title: "Stock", subtitle: "Inventory", icon: UIImage(systemName:"archivebox"), onTap: { [weak self] _ in self?.state.selectedReport = .stock }),
                    .init(title: "P&L", subtitle: "Profit & Loss", icon: UIImage(systemName:"chart.bar"), onTap: { [weak self] _ in self?.state.selectedReport = .profitLoss }),
                    .init(title: "Customers", subtitle: "Top buyers", icon: UIImage(systemName:"person.2"), onTap: { [weak self] _ in self?.state.selectedReport = .customers }),
                    .init(title: "Suppliers", subtitle: "Vendors", icon: UIImage(systemName:"truck.box"), onTap: { [weak self] _ in self?.state.selectedReport = .suppliers })
                ],
                allowsMultipleSelection: false
            )
        )
    }

    private func makeTimeFrameGrid() -> FormRow {

        let options = availableTimeframes.map { TimeframeOption(title: $0.title) }
        let selectedIndex = availableTimeframes.firstIndex(of: state.timeframe) ?? 0

        let row = TimeframeSelectorRow(
            tag: 101,
            config: TimeframeSelectorConfig(
                options: options,
                allowsMultipleSelection: false,
                selectedIndex: selectedIndex
            )
        )

        row.onSelectionChanged = { [weak self] index in
            guard let self else { return }

            let tf = self.availableTimeframes[index]
            self.state.timeframe = tf

            let range = DateFormatters.dateRange(for: tf)
            self.state.startDate = range.start
            self.state.endDate = range.end

            self.refreshUI()
        }

        row.onCustomSelected = { [weak self] in
            guard let self else { return }

            self.state.timeframe = .custom
            self.onCustomTimeframeTap?()

            self.refreshUI()
        }

        return row
    }

    private func makeFilterFormRow() -> FormRow {

        FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: "Custom Range",
                rows: [[
                    FilterFieldConfig(
                        placeholder: "Start Date",
                        selectedValue: state.startDateString,
                        onTap: { [weak self] in self?.handleStartDateSelection() }
                    ),
                    FilterFieldConfig(
                        placeholder: "End Date",
                        selectedValue: state.endDateString,
                        onTap: { [weak self] in self?.handleEndDateSelection() }
                    )
                ]],
                message: DateFormatters.displayRange(
                    start: state.startDate,
                    end: state.endDate
                ),
                showsCard: false
            )
        )
    }

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )

    // MARK: - UI Refresh (IMPORTANT FIX)
    private func refreshUI() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.timeFrame.rawValue
        }) else { return }

        sections[index].cells = makeTimeFrameCells()
        reloadSection(index)
    }

    // MARK: - DATE HANDLERS
    private func handleStartDateSelection() {
        onStartDateTap?()

        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }
            self.state.startDate = date
            self.state.startDateString = Helpers.format(date)
            self.refreshUI()
        }
    }

    private func handleEndDateSelection() {
        onEndDateTap?()

        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }
            self.state.endDate = date
            self.state.endDateString = Helpers.format(date)
            self.refreshUI()
        }
    }

    // MARK: - SUBMIT
    @MainActor
    private func submit() async {
        guard let report = state.selectedReport else { return }

        let payload = ReportSelectionPayload(
            report: report,
            timeframe: state.timeframe,
            startDate: state.startDate,
            endDate: state.endDate
        )

        gotoConfirm?(payload)
    }

    // MARK: - STATE
    private struct State {
        var selectedReport: ReportType?
        var timeframe: Timeframe = .today

        var startDate: Date?
        var endDate: Date?

        var startDateString: String?
        var endDateString: String?
    }

    // MARK: - HELPERS

    // MARK: - ENUMS
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
