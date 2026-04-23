//
//  ProfitLossReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import UIKit
import DesignSystemKit
import UtilsKit
import StorageKit

// MARK: - Profit & Loss Report VM
final class ProfitLossReportsViewModel: FormViewModel {
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
        state = State()
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            makeTitleSection(),
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
    
    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(title: "Profit & Loss", description: "View financial performance")
    
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
        case action
    }

    private enum CellTag: Int {
        case reportTitle = 0
        case continueButton = 1
    }
}

//extension ProfitLossReportsViewModel {
//    private lazy var financialCards: [FinancialCardData] = [
//        FinancialCardData(
//            title: "Available Stock",
//            icon: "chart.bar",
//            subtitle: "This month",
//            statusText: "On track",
//            statusColor: .systemGreen,
//            statusIcon: "checkmark",
//            backgroundColor: .app(.hex("#E7E9ED")),
//            action: { [weak self] in }
//        ),
//        FinancialCardData(
//            title: "Total Stock",
//            icon: "doc.text",
//            subtitle: "2 due soon",
//            statusText: "Action needed",
//            statusColor: .systemOrange,
//            statusIcon: "exclamationmark.triangle",
//            backgroundColor: .app(.hex("#E7E9ED")),
//            action: { [weak self] in }
//        ),
//        FinancialCardData(
//            title: "Estimated Profit",
//            icon: "chart.bar",
//            subtitle: "This month",
//            statusText: "On track",
//            statusColor: .systemGreen,
//            statusIcon: "checkmark",
//            backgroundColor: .app(.hex("#E7E9ED")),
//            action: { [weak self] in  }
//        ),
//        FinancialCardData(
//            title: "Total Stock Intake",
//            icon: "doc.text",
//            subtitle: "2 due soon",
//            statusText: "Action needed",
//            statusColor: .systemOrange,
//            statusIcon: "exclamationmark.triangle",
//            backgroundColor: .app(.hex("#E7E9ED")),
//            action: { [weak self] in  }
//        )
//    ]
//    
//    private func makeFinancialItem(_ data: FinancialCardData) -> DualCardItemConfig {
//        DualCardItemConfig(
//            title: data.title,
//            titleIcon: UIImage(systemName: data.icon),
//            subtitle: data.subtitle,
//            status: CardStatusStyle(
//                text: data.statusText,
//                textColor: data.statusColor,
//                backgroundColor: data.statusColor.withAlphaComponent(0.15),
//                icon: UIImage(systemName: data.statusIcon)
//            ),
//            backgroundColor: data.backgroundColor,
//            onTap: data.action
//        )
//    }
//    
//    private func makeFinancialRow(
//        _ left: FinancialCardData,
//        _ right: FinancialCardData,
//        tag: Int
//    ) -> FormRow {
//
//        DualCardFormRow(
//            tag: tag,
//            config: DualCardCellConfig(
//                left: makeFinancialItem(left),
//                right: makeFinancialItem(right)
//            )
//        )
//    }
//    
//    private func makeFinancialSummarySection() -> FormSection {
//
//        let row1 = makeFinancialRow(
//            financialCards[0],
//            financialCards[1],
//            tag: 100
//        )
//
//        let row2 = makeFinancialRow(
//            financialCards[2],
//            financialCards[3],
//            tag: 101
//        )
//
//        return FormSection(
//            id: Tags.Section.financialSummary.rawValue,
//            cells: [row1, row2]
//        )
//    }
//}
