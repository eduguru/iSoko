//
//  BasicProfileSecurityViewModel.swift
//
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit

final class BasicProfileSecurityViewModel: FormViewModel {

    // MARK: - Navigation callbacks
    var gotoTerms: (() -> Void)? = { }
    var gotoPrivacyPolicy: (() -> Void)? = { }

    var gotoVerify: ((OTPVerificationType, _ onSuccess: (() -> Void)?) -> Void)? = { _, _ in }
    var goToLogin: (() -> Void)? = { }
    var gotoConfirm: (() -> Void)? = { }

    // MARK: - Internal State
    private var state: State

    // MARK: - UI Text
    private let fullText =
    "You acknowledge you have read and agreed to our terms of use and privacy policy"

    lazy var termsRange: NSRange = {
        (fullText as NSString).range(of: "terms of use")
    }()

    lazy var privacyRange: NSRange = {
        (fullText as NSString).range(of: "privacy policy")
    }()

    // MARK: - Init
    init(builder: RegistrationBuilder, registrationType: RegistrationType) {
        self.state = State(
            registrationType: registrationType,
            builder: builder,
            phoneNumber: builder.phoneNumber,
            password: builder.password,
            confirmPassword: builder.confirmPassword,
            agreedToTerms: false
        )
        
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeSecuritySection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                makeHeaderTitleRow(),
                phoneNumberRow
            ]
        )
    }

    private func makeSecuritySection() -> FormSection {
        FormSection(
            id: Tags.Section.security.rawValue,
            title: "Set Your Password",
            cells: [
                passwordRow,
                confirmPasswordRow,
                requirementsListRow,
                termsRow,
                SpacerFormRow(tag: -1),
                continueButtonRow
            ]
        )
    }

    // MARK: - Header Row
    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: -101,
            title: "Verify your phone number",
            description: "",
            maxTitleLines: 2
        )
    }

    // MARK: - Rows
    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium
        ) { [weak self] in
            guard let self else { return }
            guard let phone = state.phoneNumber, !phone.isEmpty else {
                print("❌ No phone number provided")
                return
            }

            let otpType: OTPVerificationType = .phone(number: phone, title: "Verify your phone")
            self.goToLogin?()
//            gotoVerify?(otpType) { [weak self] in
//                self?.goToLogin?()
//            }
        }
    )

    lazy var phoneNumberRow = PhoneNumberRow(
        tag: Tags.Cells.phoneNumber.rawValue,
        model: PhoneNumberModel(
            phoneNumber: nil,
            useCardStyle: true,
            cardStyle: .border,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            onPhoneNumberChanged: { [weak self] value in
                self?.state.phoneNumber = value
                self?.state.builder.phoneNumber = value
            }
        )
    )

    lazy var passwordRow = SimpleInputFormRow(
        tag: Tags.Cells.password.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter password",
                keyboardType: .default,
                isSecureTextEntry: true,
                returnKeyType: .done
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 6,
                maxLength: 20,
                errorMessageRequired: "Password is required",
                errorMessageLength: "Password must be 6–20 characters"
            ),
            useCardStyle: true,
            cardStyle: .border,
            onTextChanged: { [weak self] text in
                self?.state.password = text
                self?.state.builder.password = text
            }
        )
    )

    lazy var confirmPasswordRow = SimpleInputFormRow(
        tag: Tags.Cells.confirmPassword.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Confirm password",
                keyboardType: .default,
                isSecureTextEntry: true,
                returnKeyType: .done
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 6,
                maxLength: 20
            ),
            useCardStyle: true,
            cardStyle: .border,
            onTextChanged: { [weak self] text in
                self?.state.confirmPassword = text
                self?.state.builder.confirmPassword = text
            }
        )
    )

    // Password requirements UI
    let config = RequirementsListRowConfig(
        title: "Password Requirements",
        items: [
            RequirementItem(title: "Must be at least 8 characters", isSatisfied: true),
            RequirementItem(title: "Include a number", isSatisfied: true),
            RequirementItem(title: "Include a special character", isSatisfied: true)
        ],
        isCardStyleEnabled: true
    )

    lazy var requirementsListRow = RequirementsListRow(tag: 1, config: config)

    lazy var termsRow = TermsCheckboxRow(
        tag: Tags.Cells.terms.rawValue,
        config: TermsCheckboxRowConfig(
            isAgreed: false,
            descriptionText: fullText,
            termsLinkRange: termsRange,
            privacyLinkRange: privacyRange,
            onToggle: { [weak self] agreed in
                self?.state.agreedToTerms = agreed
            },
            checkboxTintColor: .app(.primary),
            useCardStyle: true
        )
    )

    // MARK: - Builder Mapping
    func mapToRegistrationBuilder() -> RegistrationBuilder {
        return state.builder
    }

    // MARK: - Row Reload Helper
    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                return
            }
        }
    }

    // MARK: - State
    private struct State {
        var registrationType: RegistrationType
        var builder: RegistrationBuilder

        var phoneNumber: String?
        var password: String?
        var confirmPassword: String?
        var agreedToTerms: Bool
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case security = 1
        }

        enum Cells: Int {
            case phoneNumber = 1
            case password = 2
            case confirmPassword = 3
            case terms = 4
            case submit = 5
        }
    }
}
