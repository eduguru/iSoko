//
//  NewTradeAssociationViewModel.swift
//
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class NewTradeAssociationViewModel: FormViewModel {
    
    // MARK: - Callbacks
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    var onStep1Complete: ((_ data: [String: Any]) -> Void)?
    var gotoSelectSystemCountry: (CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) -> Void = { _, _ in }

    // MARK: - Internal State
    private var state = State()

    // MARK: - Init
    override init() {
        super.init()
        state.date = Date()
        state.dateString = Helpers.format(state.date!)
        sections = makeSections()
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    headerRow,
                    stepIndicatorRow,
                    requirementsListRow,
                    associationNameRow,
                    associationCodeRow,
                    associationDescriptionRow,
                    memberCountRow,
                    countryInputRow,
                    foundedYearRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows
    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 1)
    )

    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        model: TitleDescriptionModel(
            title: "Register Association",
            description: "Join the iSOKO network and expand your association's reach"
        )
    )
    
    private lazy var associationNameRow = SimpleInputFormRow(
        tag: CellTag.associationName.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(placeholder: "Association Name"),
            validation: ValidationConfiguration(isRequired: true, minLength: 3, maxLength: 50),
            titleText: "Association Name",
            useCardStyle: true,
            onTextChanged: { [weak self] text in
                self?.state.name = text
            }
        )
    )
    
    private lazy var associationCodeRow = SimpleInputFormRow(
        tag: CellTag.associationCode.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(placeholder: "Association Code"),
            validation: ValidationConfiguration(isRequired: true, minLength: 3, maxLength: 50),
            titleText: "Association Code",
            useCardStyle: true,
            onTextChanged: { [weak self] text in
                self?.state.code = text
            }
        )
    )

    private lazy var associationDescriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "Description",
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Association Description",
            useCardStyle: false,
            onTextChanged: { [weak self] text in
                self?.state.description = text
            }
        )
    )

    private lazy var memberCountRow = SimpleInputFormRow(
        tag: CellTag.memberCount.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(placeholder: "Number of Members"),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Number of Members",
            useCardStyle: true
        )
    )

    private lazy var foundedYearRow = DropdownFormRow(
        tag: CellTag.foundedYear.rawValue,
        config: DropdownFormConfig(
            title: "Founded Year",
            placeholder: state.dateString,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                guard let self else { return }
                let config = DatePickerConfig.year()
                self.goToDateSelection(config) { selectedDate in
                    guard let date = selectedDate else { return }
                    self.state.date = date
                    self.state.dateString = Helpers.format(date)
                    self.handleDateSelection()
                }
            }
        )
    )
    
    private lazy var countryInputRow = DropdownFormRow(
        tag: CellTag.country.rawValue,
        config: DropdownFormConfig(
            title: "Country",
            placeholder: "Country",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleCountrySelection()
            }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.completeStep1()
        }
    )

    private let config = RequirementsListRowConfig(
        title: "Requirements",
        items: [
            RequirementItem(title: "Valid registration documents", isSatisfied: true),
            RequirementItem(title: "Minimum 5 active members", isSatisfied: true),
            RequirementItem(title: "Established for at least 1 year", isSatisfied: true),
            RequirementItem(title: "East African region based", isSatisfied: true)
        ]
    )

    lazy var requirementsListRow = RequirementsListRow(tag: 1, config: config)

    // MARK: - Handlers
    private func handleDateSelection() {
        var config = foundedYearRow.config
        config.placeholder = state.dateString
        foundedYearRow.config = config
        reloadRow(withTag: foundedYearRow.tag)
    }
    
    private func handleCountrySelection() {
        gotoSelectSystemCountry(.countries(page: 0, count: 10)) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state.selectedCountry = value
            let dropdownFormRow: DropdownFormRow = countryInputRow
            
            dropdownFormRow.config.placeholder = value.name ?? ""
            self.reloadRow(withTag: dropdownFormRow.tag)
        }
    }

    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    private func completeStep1() {
        var step1Data: [String: Any] = [:]
        step1Data["name"] = state.name
        step1Data["code"] = state.code
        step1Data["description"] = state.description
        step1Data["members"] = Int(memberCountRow.model.text) ?? 0
        step1Data["countryId"] = state.selectedCountry?.id ?? 0

        // Pass only the year as Int
        if let date = state.date {
            step1Data["foundedIn"] = date.getComponent(.year)
        } else {
            step1Data["foundedIn"] = 0
        }

        onStep1Complete?(step1Data)
    }

    // MARK: - State
    private struct State {
        var name: String = ""
        var code: String = ""
        var description: String = ""
        var date: Date?
        var dateString: String = ""
        var selectedCountry: CountryResponse?
    }

    private enum SectionTag: Int { case main = 0 }
    private enum CellTag: Int {
        case header = 1, steps, associationName, description, memberCount, foundedYear, continueButton, associationCode, country
    }
}
