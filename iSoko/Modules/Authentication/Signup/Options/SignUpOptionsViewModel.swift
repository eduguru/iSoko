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
    var goToContinue: (() -> Void)? = { }
    var goBack: (() -> Void)? = { }
    var goToOtp: ((OTPVerificationType, _ onSuccess: (() -> Void)?) -> Void)? = { _, _ in }
    var goToCompleteProfile: ((_ builder: RegistrationBuilder) -> Void)? = { _ in }
    
    var gotoSignUpWithGoogle: (() -> Void)? = { }
    var gotoGuestSession: (() -> Void)? = { }
    var gotoSignIn: (() -> Void)? = { }
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)? = { _ in }

    // MARK: - State
    private var state: State
    let countryHelper = CountryHelper()

    // MARK: - Init
    init(builder: RegistrationBuilder) {
        self.state = State(registrationBuilder: builder)
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
                navBarRow,
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

    // MARK: Email Input
    lazy var emailInputRow: SimpleInputFormRow = {
        var model = SimpleInputModel(
            text: state.email ?? "",
            config: TextFieldConfig(
                placeholder: "Email Address",
                keyboardType: .emailAddress
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 3,
                maxLength: 50
            ),
            titleText: nil,
            useCardStyle: true,
            onTextChanged: { [weak self] newText in
                guard let self = self else { return }
                self.state.email = newText
                self.state.registrationBuilder.email = newText
            },
            onValidationError: { error in
                print("Email validation error: \(String(describing: error))")
            }
        )
        return SimpleInputFormRow(tag: Tags.Cells.emailInput.rawValue, model: model)
    }()

    // MARK: Phone Input
    lazy var phoneDropDownRow: PhoneDropDownFormRow = {
        PhoneDropDownFormRow(
            tag: Tags.Cells.phoneDropDown.rawValue,
            model: PhoneDropDownModel(
                phoneNumber: state.phoneNumber ?? "",
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
                onPhoneChanged: { [weak self] new in
                    guard let self = self else { return }
                    self.state.phoneNumber = new
                    self.state.registrationBuilder.phoneNumber = new
                },
                onCountryTapped: { [weak self] in
                    self?.showCountryPicker? { selectedCountry in
                        self?.updatePhoneCountry(selectedCountry)
                    }
                },
                onValidationError: { err in
                    print("Phone validation error: \(String(describing: err))")
                }
            )
        )
    }()

    private func updatePhoneCountry(_ newCountry: Country) {
        var model = phoneDropDownRow.model
        model.selectedCountry = newCountry
        phoneDropDownRow.model = model
        reloadRowWithTag(phoneDropDownRow.tag)
        state.registrationBuilder.country = IDNamePairInt(id: Int(newCountry.id) ?? 0, name: newCountry.name)
    }

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            title: "Create an Account",
            description: "Join a network of Traders and grow your network.",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .subheadline
        )
    }

    // MARK: Continue Button
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
            guard let self = self else { return }

            if self.state.isUsingPhone {
                let phoneModel = self.phoneDropDownRow.model
                let phone = phoneModel.phoneNumber.trimmingCharacters(in: .whitespaces)
                let phoneCode = phoneModel.selectedCountry.phoneCode
                guard !phone.isEmpty else { return }
                let fullPhone = "\(phoneCode)\(phone)"
                self.goToOtp?(.phone(number: fullPhone, title: "Verify your phone")) { [weak self] in
                    guard let self = self else { return }
                    self.goToCompleteProfile?(self.state.registrationBuilder)
                }
            } else {
                let email = self.emailInputRow.model.text.trimmingCharacters(in: .whitespaces)
                guard !email.isEmpty else { return }
                self.goToOtp?(.email(address: email, title: "Verify your email")) { [weak self] in
                    guard let self = self else { return }
                    self.goToCompleteProfile?(state.registrationBuilder)
                }
            }
        }
    )

    // MARK: Email / Google Buttons
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
                self?.gotoSignUpWithGoogle?()
            }
        )
    )

    // MARK: Navigation Bar
    lazy var leftButtonConfig = NavigationBarButtonConfig(
        image: .backArrow,
        action: { [weak self] in
            self?.goBack?()
        }
    )

    lazy var navBarConfig = NavigationBarConfig(
        leftButton: leftButtonConfig,
        rightButton: nil
    )

    lazy var navBarRow = NavigationBarFormRow(tag: 1, navBarConfig: navBarConfig)

    // MARK: Helpers
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

    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                break
            }
        }
    }

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {}

    // MARK: Nested Types
    private struct State {
        var registrationBuilder: RegistrationBuilder
        var isUsingPhone: Bool = false
        var email: String?
        var phoneNumber: String?
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
