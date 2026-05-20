//
//  BasicProfileSecurityViewModel.swift
//
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class BasicProfileSecurityViewModel: FormViewModel {

    // MARK: - Navigation callbacks
    var gotoTerms: (() -> Void)?
    var gotoPrivacyPolicy: (() -> Void)?
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    var gotoVerify: ((OTPVerificationType, (() -> Void)?) -> Void)?
    var goToLogin: (() -> Void)?
    var gotoConfirm: (() -> Void)?

    // MARK: - Internal State
    private let countryHelper = CountryHelper()
    private let authenticationService = NetworkEnvironment.shared.authenticationService
    private var state: State

    // MARK: - UI Text
    private let fullText = "common.basic_profile_security.terms_text".localized
    lazy var termsRange = (fullText as NSString).range(of: "terms of use")
    lazy var privacyRange = (fullText as NSString).range(of: "common.help_feedback.privacy_policy".localized)

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
            FormSection(id: Tags.Section.header.rawValue, title: nil, cells: [makeHeaderTitleRow()]),
            FormSection(
                id: Tags.Section.security.rawValue,
                title: "common.basic_profile_security.set_password_title".localized,
                cells: [
                    passwordRow,
                    confirmPasswordRow,
                    requirementsListRow,
                    termsRow,
                    SpacerFormRow(tag: -1),
                    continueButtonRow
                ]
            )
        ]
    }

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: -101,
            model: TitleDescriptionModel(
                title: "common.basic_profile_security.header_title".localized,
                description: "",
                maxTitleLines: 2
            )
        )
    }

    // MARK: - Rows
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
                maxLength: 20,
                errorMessageRequired: "Confirm password is required",
                errorMessageLength: "Confirm password must be 6–20 characters"
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
    private let config = RequirementsListRowConfig(
        title: "common.basic_profile_security.password_requirement_special".localized,
        items: [
            RequirementItem(title: "common.basic_profile_security.password_requirement_length".localized, isSatisfied: true),
            RequirementItem(title: "common.basic_profile_security.password_requirement_number".localized, isSatisfied: true),
            RequirementItem(title: "common.basic_profile_security.password_requirement_special".localized, isSatisfied: true)
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

    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "common.button.continue".localized,
            style: .primary,
            size: .medium
        ) { [weak self] in
            guard let self = self else { return }
            guard self.state.agreedToTerms else {
                print("❌ User must agree to terms")
                return
            }
            guard self.state.password == self.state.confirmPassword else {
                print("❌ Passwords do not match")
                showError("Passwords do not match")
                return
            }
            
            Task {
                let success = await self.performRegistration()
                if success { self.goToLogin?() }
            }
        }
    )

    // MARK: - Registration
    @discardableResult
    private func performRegistration() async -> Bool {
        showLoader()
        defer { hideLoader() }

        do {
            // Explicit type so Swift knows which map function to call
            let built: RegistrationRequest = try state.builder.build()
            
            // Map to server dictionary
            let params: [String: Any] = built.mapToCreateUserRequest()
            
            // Call API
            let _ = try await authenticationService.registerUser(params, accessToken: state.guestToken)
            
            return true
        } catch let NetworkError.server(response) {
            print("🚫 Server error:", response.message ?? "Unknown")
            response.errors?.forEach {
                print("Field:", $0.field ?? "-", "Message:", $0.message ?? "-")
            }
            state.errorMessage = response.message
            state.fieldErrors = response.errors
            
            showError(state.errorMessage ?? "An error occurred. Please try again.")
            return false
        } catch {
            print("❌ Registration Error:", error)
            state.errorMessage = "Something went wrong. Please try again."
            showError(state.errorMessage ?? "An error occurred. Please try again.")
            
            return false
        }
    }

    // MARK: - State
    private struct State {
        var registrationType: RegistrationType
        var builder: RegistrationBuilder

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var phoneNumber: String?
        var password: String?
        var confirmPassword: String?
        var agreedToTerms: Bool

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int { case header = 0, security = 1 }
        enum Cells: Int {
            case phoneNumber = 1, password = 2, confirmPassword = 3, terms = 4, submit = 5, email = 6, phoneDropDown = 7
        }
    }
}
