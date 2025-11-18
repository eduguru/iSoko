//
//  CompleteNewTradeAssociationViewModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class CompleteNewTradeAssociationViewModel: FormViewModel {

    // MARK: - Navigation
    var gotoSelectLocation: ((_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)?
    var gotoConfirm: (() -> Void)?

    // MARK: - Country Picker (for phone)
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    private let countryHelper = CountryHelper()

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
                    phoneDropDownRow,            // 📞 Phone number now added here
                    websiteInputRow,
                    instagramInputRow,
                    linkedinInputRow,
                    xInputRow,
                    locationDropdownRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - UI Rows

    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 2)
    )

    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        title: "Complete Association Registration",
        description: "Add your contact and location details to help members find your association easily.",
        maxTitleLines: 2,
        layoutStyle: .stackedVertical,
        textAlignment: .left,
        titleFontStyle: .title,
        descriptionFontStyle: .headline
    )

    // MARK: - 📞 Phone Number Field
    private lazy var phoneDropDownRow = PhoneDropDownFormRow(
        tag: CellTag.phone.rawValue,
        model: PhoneDropDownModel(
            phoneNumber: "",
            selectedCountry: countryHelper.country(forISO: "KE")!,
            placeholder: "Enter phone number",
            titleText: "Phone Number",
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 5,
                maxLength: 15,
                errorMessageRequired: "Phone number is required",
                errorMessageLength: "Phone number length is invalid"
            ),
            onPhoneChanged: { new in
                print("Phone changed: \(new)")
            },
            onCountryTapped: { [weak self] in
                self?.showCountryPicker? { selectedCountry in
                    self?.updatePhoneCountry(selectedCountry)
                }
            },
            onValidationError: { err in
                if let err = err {
                    print("Validation error: \(err)")
                }
            }
        )
    )

    private func updatePhoneCountry(_ newCountry: Country) {
        var model = phoneDropDownRow.model
        model.selectedCountry = newCountry
        phoneDropDownRow.model = model
        reloadRow(withTag: phoneDropDownRow.tag)
    }

    // MARK: - Other Input Fields

    private lazy var websiteInputRow = SimpleInputFormRow(
        tag: CellTag.website.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter website URL",
                keyboardType: .URL
            ),
            validation: ValidationConfiguration(isRequired: false),
            titleText: "Website URL (Optional)",
            useCardStyle: true
        )
    )

    private lazy var instagramInputRow = SimpleInputFormRow(
        tag: CellTag.instagram.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter Instagram URL",
                keyboardType: .URL
            ),
            validation: ValidationConfiguration(isRequired: false),
            titleText: "Instagram URL (Optional)",
            useCardStyle: true
        )
    )

    private lazy var linkedinInputRow = SimpleInputFormRow(
        tag: CellTag.linkedin.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter LinkedIn URL",
                keyboardType: .URL
            ),
            validation: ValidationConfiguration(isRequired: false),
            titleText: "LinkedIn URL (Optional)",
            useCardStyle: true
        )
    )

    private lazy var xInputRow = SimpleInputFormRow(
        tag: CellTag.xURL.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter X (Twitter) URL",
                keyboardType: .URL
            ),
            validation: ValidationConfiguration(isRequired: false),
            titleText: "X URL (Optional)",
            useCardStyle: true
        )
    )

    private lazy var locationDropdownRow = DropdownFormRow(
        tag: CellTag.location.rawValue,
        config: DropdownFormConfig(
            title: "Business Location",
            placeholder: state.businessLocation?.name ?? "Select location",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleLocationSelection()
            }
        )
    )

    // MARK: - Continue Button
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

    // MARK: - Selection Handler
    private func handleLocationSelection() {
        gotoSelectLocation? { [weak self] value in
            guard let self, let value else { return }
            state.businessLocation = value
            locationDropdownRow.config.placeholder = value.name
            reloadRow(withTag: locationDropdownRow.tag)
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
        var businessLocation: CommonIdNameModel?
    }

    // MARK: - Tags
    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case header = 1
        case steps = 2
        case phone = 3
        case website = 4
        case instagram = 5
        case linkedin = 6
        case xURL = 7
        case location = 8
        case continueButton = 9
    }
}
