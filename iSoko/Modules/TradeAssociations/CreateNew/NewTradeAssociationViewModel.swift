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
    var gotoSelectGender: (_ options: [CommonIdNameModel], _ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _, _ in }
    var gotoSelectAgeRange: (_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _ in }
    var gotoConfirm: (() -> Void)? = { }
    
    private var state: State?

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []

        sections.append(FormSection(
            id: Tags.Section.body.rawValue,
            cells: [
                headerTitleRow,
                stepsRow,
                nameInputRow,
                descriptionInputRow,
                selectGenderRow,
                selectAgeRangeRow,
                
                SpacerFormRow(tag: 20),
                continueButtonRow
            ]
        ))

        return sections
    }

    // MARK: - Lazy or Computed Rows
    lazy var stepsRow = makeStepsRow()
    lazy var headerTitleRow = makeHeaderTitleRow()
    
    lazy var nameInputRow = makeNameInputRow()
    lazy var descriptionInputRow = makeDescriptionInputRow()
    
    lazy var selectGenderRow = makeGenderRow()
    lazy var selectAgeRangeRow = makeAgeRangeRow()
    
    private func makeStepsRow() -> StepStripFormRow {
        StepStripFormRow(
            tag: 001,
            model: StepStripModel(totalSteps: 2, currentStep: 1)
        )
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: 002,
            title: "Register Association",
            description: "Join the iSOKO network and expand your association's reach",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
    }
    
    private func makeNameInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.firstName.rawValue,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(placeholder: "First name", keyboardType: .default),
                validation: ValidationConfiguration(isRequired: true, minLength: 3, maxLength: 50),
                titleText: "First name",
                useCardStyle: true
            )
        )
    }
    
    private func makeDescriptionInputRow() -> LongInputDescriptionFormRow {
        LongInputDescriptionFormRow(
            tag: Tags.Cells.description.rawValue,
            model: LongInputDescriptionModel(
                text: "",
                config: TextViewConfig(
                    prefixText: "Description",
                    accessoryImage: UIImage(systemName: "pencil"),
                    isScrollable: true,
                    fixedHeight: 120
                ),
                validation: ValidationConfiguration(isRequired: true),
                titleText: "Enter description",
                useCardStyle: false,  // Use card style here
                cardStyle: .borderAndShadow,  // Card style configuration
                cardCornerRadius: 12,  // Custom corner radius
                cardBorderColor: .app(.primary),  // Custom border color
                cardShadowColor: .gray,  // Custom shadow color
                onTextChanged: { newText in
                    print("Text changed to: \(newText)")
                },
                onValidationError: { error in
                    if let error = error {
                        print("Validation error: \(error)")
                    }
                }
            )
        )
    }


    
    private func makeAgeRangeRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.ageGroup.rawValue,
            config: DropdownFormConfig(
                title: "Select Age Range",
                placeholder: state?.ageRange?.name ?? "Age Range",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.handleAgeRangeSelection()
                }
            )
        )
    }
    
    private func makeGenderRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.gender.rawValue,
            config: DropdownFormConfig(
                title: "Select Gender",
                placeholder: state?.gender?.name ?? "Gender",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.handleGenderSelection()
                }
            )
        )
    }
    
    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
    )
    
    // MARK: - Selection Handlers

    private func handleGenderSelection() {
        gotoSelectGender(state?.genderOptions ?? []) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.gender = value
            self.selectGenderRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }
    
    private func handleAgeRangeSelection() {
        gotoSelectAgeRange { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.ageRange = value
            self.selectAgeRangeRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
        }
    }
    
    // MARK: - Helpers

    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
    // MARK: - State

    private struct State {
        var isLoggedIn: Bool = true
        
        var firstName: String?
        var lastName: String?
        var genderOptions: [CommonIdNameModel] = [
            CommonIdNameModel(id: 1, name: "Male"),
            CommonIdNameModel(id: 2, name: "Female")
        ]
        var gender: CommonIdNameModel?
        var ageRange: CommonIdNameModel?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }

        enum Cells: Int {
            case headerImage = 0
            case firstName = 1
            case gender = 2
            case ageGroup = 3
            case email = 4
            case phoneNumber = 5
            case submit = 6
            case description = 7
            
        }
    }
}
