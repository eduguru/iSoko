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
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            makeTitleSection(),
            makeFilterSection(),
            makeSelectionSection(),
            makeRecentActivitiesSection(),
            makeActionSection()
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
                            onTap: {
                                print("tapped")
                            }
                        )
                    ],
                    [
                        FilterFieldConfig(
                            placeholder: "Start Date",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "End Date",
                            selectedValue: nil,
                            iconSystemName: "calendar",
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
    
    private func makeSelectionGrid() -> FormRow {

        SelectableCardGridRow(
            tag: CellTag.category.rawValue,
            config: .init(
                items: [
                    .init(
                        title: "Available Stock",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                        }),
                    .init(
                        title: "Available Stock",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                        }),
                    .init(
                        title: "Available Stock",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                        }),
                    .init(
                        title: "Available Stock",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                        }),
                    .init(
                        title: "Available Stock",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                        }),
                    .init(
                        title: "Available Stock",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                        })
                    
                ],
                allowsMultipleSelection: false
            )
        )
    }
    
    // Lazy factory that creates rows
    func makeTransactionActionRows() -> [FormRow] {
        (0..<10).map { index in

            let hasActions = index.isMultiple(of: 2)

            let config = TransactionActionsCellConfig(
                title: "Paper Cups \(index + 1)",
                subtitle: "\(index + 1) packs available",
                amount: "$\(Int.random(in: 10...250)).00",
                amountColor: .label,
                status: "",
                statusColor: .app(.hex("#717171")),
                primaryAction: hasActions
                    ? ActionCardConfig(
                        title: "View details",
                        icon: UIImage(systemName: "creditcard"),
                        backgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                        textColor: .app(.hex("#656C7A")),
                        onTap: {
                            print("Pay tapped on row \(index)")
                        }
                    )
                    : nil,
                secondaryAction: hasActions
                    ? InlineActionConfig(
                        title: "Edit",
                        icon: UIImage(systemName: "pencil"),
                        onTap: {
                            print("Edit tapped on row \(index)")
                        }
                    )
                    : nil
            )

            return TransactionActionsRow(
                tag: index,
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
