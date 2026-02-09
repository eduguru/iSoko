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
    // OUTPUT
    var foundedYear: Int?
    var billingMonth: Date?
    var birthDate: Date?
    
    // MARK: - Navigation Callbacks // INPUT (callbacks)
    var selectFoundedYear: ((_ completion: @escaping (Int?) -> Void) -> Void)?
    var selectBillingMonth: ((_ completion: @escaping (Date?) -> Void) -> Void)?
    var selectBirthDate: ((_ completion: @escaping (Date?) -> Void) -> Void)?
    
    var gotoSelectMemberCount: ((_ options: [CommonIdNameModel], _ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)? = nil
    var gotoConfirm: (() -> Void)?
    
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
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    headerRow,
                    stepIndicatorRow,
                    requirementsListRow,
                    associationNameRow,
                    associationDescriptionRow,
                    memberCountRow,
                    foundedYearRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }
    
    // MARK: - Form Rows
    
    // Step indicator at top
    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 1)
    )
    
    // Header title
    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        title: "Register Association",
        description: "Join the iSOKO network and expand your association's reach",
        maxTitleLines: 2,
        layoutStyle: .stackedVertical,
        textAlignment: .left,
        titleFontStyle: .title,
        descriptionFontStyle: .headline
    )
    
    // Association name input
    private lazy var associationNameRow = SimpleInputFormRow(
        tag: CellTag.associationName.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Association Name",
                keyboardType: .default
            ),
            validation: ValidationConfiguration(isRequired: true, minLength: 3, maxLength: 50),
            titleText: "Association Name",
            useCardStyle: true
        )
    )
    
    // Description input (multiline)
    private lazy var associationDescriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "Description",
                accessoryImage: UIImage(systemName: "pencil"),
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Association Description",
            useCardStyle: false,
            cardStyle: .borderAndShadow,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            cardShadowColor: .gray,
            onTextChanged: { newText in
                print("Description changed to: \(newText)")
            },
            onValidationError: { error in
                if let error = error {
                    print("Validation error: \(error)")
                }
            }
        )
    )
    
    // Member count dropdown
    private lazy var memberCountRow = DropdownFormRow(
        tag: CellTag.memberCount.rawValue,
        config: DropdownFormConfig(
            title: "Number of Members",
            placeholder: state.memberCount?.name ?? "Select number of members",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleMemberCountSelection()
            }
        )
    )
    
    // Founded year dropdown
    private lazy var foundedYearRow = DropdownFormRow(
        tag: CellTag.foundedYear.rawValue,
        config: DropdownFormConfig(
            title: "Founded Year",
            placeholder: "\(state.foundedYear ?? 0000)",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleFoundedYearSelection()
            }
        )
    )
    
    // Continue button
    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
    )
    
    // Create a config with your preferences
    let config = RequirementsListRowConfig(
        title: "Requirements",
        items: [
            RequirementItem(title: "Valid registration documents", isSatisfied: true),
            RequirementItem(title: "Minimum 5 active members", isSatisfied: true),
            RequirementItem(title: "Established for at least 1 year", isSatisfied: true),
            RequirementItem(title: "East African region based", isSatisfied: true)
        ],
        titleColor: .app(.primary),        // configurable title color
        itemColor: .label,              // configurable item text color
        selectionStyle: .checkbox,      // or .dot
        isCardStyleEnabled: true,       // card background with rounded corners
        cardCornerRadius: 12,
        cardBackgroundColor: .systemGray6,
        cardBorderColor: .systemGray3,
        cardBorderWidth: 1,
        spacing: 10,
        contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    )
    
    // Initialize your RequirementsListRow
    lazy var requirementsListRow = RequirementsListRow(tag: 1, config: config)
    
    // MARK: - Selection Handlers
    
    private func handleMemberCountSelection() {
        gotoSelectMemberCount?(state.memberCountOptions) { [weak self] value in
            guard let self, let value else { return }
            state.memberCount = value
            memberCountRow.config.placeholder = value.name
            reloadRow(withTag: memberCountRow.tag)
        }
    }
    
    private func handleFoundedYearSelection() {
        selectFoundedYear? { [weak self] value in
            guard let self, let value else { return }
            state.foundedYear = value
            foundedYearRow.config.placeholder = "\(value)"
            reloadRow(withTag: foundedYearRow.tag)
        }
    }
    
    // MARK: - Helpers
    
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
    // MARK: - State
    
    private struct State {
        var memberCountOptions: [CommonIdNameModel] = [
            CommonIdNameModel(id: 1, name: "1–50 members"),
            CommonIdNameModel(id: 2, name: "51–200 members"),
            CommonIdNameModel(id: 3, name: "200+ members")
        ]
        var memberCount: CommonIdNameModel?
        var foundedYear: Int?
    }
    
    // MARK: - Tags
    
    private enum SectionTag: Int {
        case main = 0
    }
    
    private enum CellTag: Int {
        case header = 1
        case steps = 2
        case associationName = 3
        case description = 4
        case memberCount = 5
        case foundedYear = 6
        case continueButton = 7
    }
}
