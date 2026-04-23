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

    // REQUIRED (same pattern as your other VM)
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
            cells: [
                makeTitleRow(),
                makeSelectionGrid()
            ]
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
            cells: [
                timeFrameRow,
                makeFilterFormRow()
            ]
        )
    }

    private func makeActionSection() -> FormSection {
        FormSection(
            id: SectionTag.action.rawValue,
            cells: [continueButtonRow]
        )
    }

    // MARK: - ROWS
    private lazy var timeFrameRow: FormRow = makeTimeFrameGrid()

    private func makeTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: CellTag.reportTitle.rawValue,
            model: TitleDescriptionModel(
                title: "Select Report Type",
                description: "Choose a report to view your business performance",
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

        let options = availableTimeframes.map { TimeframeOption(title: $0.title) }

            let selectedIndex: Int = {
                guard let index = availableTimeframes.firstIndex(of: state.timeframe) else {
                    return 0
                }
                return index
            }()

            let config = TimeframeSelectorConfig(
                options: options,
                allowsMultipleSelection: false,
                selectedIndex: selectedIndex
            )

            let row = TimeframeSelectorRow(tag: 101, config: config)

        row.onSelectionChanged = { [weak self] index in
            guard let self else { return }

            let timeframe = self.availableTimeframes[index]
            self.state.timeframe = timeframe

            let range = DateFormatters.dateRange(for: timeframe)
            self.state.startDate = range.start
            self.state.endDate = range.end

            self.updateFilterSection()
        }

        row.onCustomSelected = { [weak self] in
            guard let self else { return }

            self.state.timeframe = .custom
            self.onCustomTimeframeTap?()

            self.updateFilterSection()
        }

        return row
    }

    private func makeFilterFormRow() -> FormRow {

        FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: state.timeframe == .custom ? "Custom Range" : "Date Range",
                rows: [
                    [
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
                    ]
                ],
                message: state.timeframe == .custom
                    ? DateFormatters.displayRange(start: state.startDate, end: state.endDate)
                    : nil,
                showsCard: false
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
            Task { await self?.submit() }
        }
    )

    // MARK: - FILTER UI UPDATE
    private func updateFilterSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.timeFrame.rawValue
        }) else { return }

        sections[index].cells = [
            timeFrameRow,
            makeFilterFormRow()
        ]

        reloadSection(index)
    }

    // MARK: - DATE HANDLERS (FIXED)

    private func handleStartDateSelection() {

        onStartDateTap?()

        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }

            self.state.startDate = date
            self.state.startDateString = Self.format(date)

            self.updateFilterSection()
        }
    }

    private func handleEndDateSelection() {

        onEndDateTap?()

        goToDateSelection(.year()) { [weak self] date in
            guard let self, let date else { return }

            self.state.endDate = date
            self.state.endDateString = Self.format(date)

            self.updateFilterSection()
        }
    }

    // MARK: - SUBMIT

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

    private static func format(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }

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
