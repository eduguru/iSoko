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

// MARK: - Expenses Report VM
final class ExpensesReportsViewModel: FormViewModel {
    var gotoConfirm: ((ReportSelectionPayload) -> Void)?
    var onStartDateTap: (() -> Void)?
    var onEndDateTap: (() -> Void)?
    var onCustomTimeframeTap: (() -> Void)?
    
    private var state = State()
    
    override init() {
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

    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(title: "Expenses Report", description: "Monitor your spending")
    
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
    }

    private enum CellTag: Int {
        case reportTitle = 0
        case continueButton = 1
    }
}
