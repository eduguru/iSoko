//
//  SignUpOptionsViewModel.swift
//
//
//  Created by Edwin Weru on 07/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class SignUpOptionsViewModel: FormViewModel {

    // MARK: - Callbacks

    var gotoSignIn: (() -> Void)? = { }
    var gotoSignUp: (() -> Void)? = { }
    var gotoGuestSession: (() -> Void)? = { }
    var gotoForgotPassword: (() -> Void)? = { }
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)? = { _ in }

    // MARK: - State

    private var state: State
    let countryHelper = CountryHelper()

    // MARK: - Init

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Section Builders

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeCredentialsSection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                SpacerFormRow(tag: Tags.Cells.spacer1.rawValue),
                makeHeaderTitleRow(),
                SpacerFormRow(tag: Tags.Cells.spacer2.rawValue),
            ]
        )
    }

    private func makeCredentialsSection() -> FormSection {
        var cells: [FormRow] = [
            SpacerFormRow(tag: Tags.Cells.spacer1.rawValue),
            state.isUsingPhone ? phoneDropDownRow : emailInputRow,
            continueButtonRow,
            DividerWithTextFormRow(tag: Tags.Cells.divider.rawValue, text: "Or"),
            emailButtonRow,
            googleButtonRow
        ]

        return FormSection(
            id: Tags.Section.credentials.rawValue,
            title: nil,
            titleStyle: FormSection.TitleStyle(
                font: .systemFont(ofSize: 18, weight: .semibold),
                color: .app(.textOnBackground)
            ),
            actionTitle: "View More",
            onActionTapped: {
                print("👀 View More tapped for credentials section")
            },
            cells: cells
        )
    }

    // MARK: - Row Builders

    lazy var emailInputRow = makeEmailInputRow()

    private func makeEmailInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.emailInput.rawValue,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: "Email Address",
                    keyboardType: .default
                ),
                validation: ValidationConfiguration(
                    isRequired: true,
                    minLength: 3,
                    maxLength: 50
                ),
                titleText: nil,
                useCardStyle: true
            )
        )
    }

    lazy var phoneDropDownRow = PhoneDropDownFormRow(
        tag: Tags.Cells.phoneDropDown.rawValue,
        model: PhoneDropDownModel(
            phoneNumber: "",
            selectedCountry: countryHelper.country(forISO: "KE")!,
            placeholder: "Enter phone number",
            titleText: nil,
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 5,
                maxLength: 15,
                errorMessageRequired: "Phone is required",
                errorMessageLength: "Phone length invalid"
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
                print("Validation error: \(String(describing: err))")
            }
        )
    )

    private func updatePhoneCountry(_ newCountry: Country) {
        var model = phoneDropDownRow.model
        model.selectedCountry = newCountry
        phoneDropDownRow.model = model
        reloadRowWithTag(phoneDropDownRow.tag)
    }

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            title: "Sign up",
            description: "",
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

    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoSignIn?()
        }
    )

    lazy var emailButtonRow = ButtonFormRow(
        tag: Tags.Cells.emailButton.rawValue,
        model: makeEmailButtonModel()
    )

    lazy var googleButtonRow = ButtonFormRow(
        tag: Tags.Cells.googleButton.rawValue,
        model: ButtonFormModel(
            title: "Continue with Google",
            style: .custom(
                backgroundColor: .white,
                textColor: .app(.secondary),
                borderColor: .app(.secondary),
                cornerRadius: 12
            ),
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true,
            action: { [weak self] in
                self?.gotoSignUp?()
            }
        )
    )

    // MARK: - Helpers

    private func makeEmailButtonModel() -> ButtonFormModel {
        let title = state.isUsingPhone ? "Continue with Email" : "Continue with Phone"
        return ButtonFormModel(
            title: title,
            style: .custom(
                backgroundColor: .white,
                textColor: .app(.primary),
                borderColor: .app(.primary),
                cornerRadius: 12
            ),
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true,
            action: { [weak self] in
                self?.toggleEmailPhoneInput()
            }
        )
    }

    private func toggleEmailPhoneInput() {
        state.isUsingPhone.toggle()

        emailButtonRow.model = makeEmailButtonModel()

        self.sections = makeSections()
        onReloadData?()
    }

    // MARK: - Reload Helpers

    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                break
            }
        }
    }

    // MARK: - Selection Handling

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
        case Tags.Section.credentials.rawValue:
            print("Credentials section row selected: \(row.tag)")
        default:
            break
        }
    }

    // MARK: - Nested Types

    private struct State {
        var isUsingPhone: Bool = false
    }

    enum Tags {
        enum Section: Int {
            case header = 0
            case credentials = 1
        }

        enum Cells: Int {
            case spacer1 = 1001
            case spacer2 = 1002
            case emailInput = 1003
            case continueButton = 1004
            case emailButton = 1005
            case googleButton = 1006
            case headerTitle = 101
            case phoneDropDown = 9100
            case divider = -1
        }
    }
}
