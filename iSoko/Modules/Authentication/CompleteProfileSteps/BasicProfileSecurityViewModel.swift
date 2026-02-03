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

final class BasicProfileSecurityViewModel: FormViewModel {

    // MARK: - Navigation callbacks
    var gotoTerms: (() -> Void)? = { }
    var gotoPrivacyPolicy: (() -> Void)? = { }
    
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)? = { _ in }

    var gotoVerify: ((OTPVerificationType, _ onSuccess: (() -> Void)?) -> Void)? = { _, _ in }
    var goToLogin: (() -> Void)? = { }
    var gotoConfirm: (() -> Void)? = { }

    // MARK: - Internal State
    let countryHelper = CountryHelper()
    let authenticationService = NetworkEnvironment.shared.authenticationService
    
    private var state: State

    // MARK: - UI Text
    private let fullText = "You acknowledge you have read and agreed to our terms of use and privacy policy"

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
                phoneDropDownRow, // phoneNumberRow,
                emailRow
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
            title: "Verify",
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
            
            self.performRegistration()
        }
    )

    private lazy var emailRow = TitleDescriptionFormRow(
        tag: -00012,
        title: "Email Address",
        description: "Enter your email",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
    )
    
    lazy var emailInputRow = SimpleInputFormRow(
        tag: Tags.Cells.email.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder:  "Enter email",
                keyboardType: .emailAddress,
                accessoryImage: nil
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 3,
                maxLength: 50,
                errorMessageRequired: "Email is required",
                errorMessageLength: "Must be 5–50 characters"
            ),
            titleText: "Email address",
            useCardStyle: true,
            onTextChanged: { [weak self] in
                self?.state.builder.email = $0
            }
        )
    
    )

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
                    self.state.phoneNumber = "+254" + new
                    self.state.builder.phoneNumber = self.state.phoneNumber
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

    // MARK: - Builder Mapping & more funcs
    func mapToRegistrationBuilder() -> RegistrationBuilder {
        return state.builder
    }
    
    private func updatePhoneCountry(_ newCountry: Country) {
        var model = phoneDropDownRow.model
        model.selectedCountry = newCountry
        phoneDropDownRow.model = model
        reloadRowWithTag(phoneDropDownRow.tag)
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
    
    // MARK: - network calls -
    private func performRegistration() -> Task<Void, Never> {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                let response = try await authenticationService.register(state.builder.build(), accessToken: state.accessToken)
                // let response = try await AuthenticationApi.register(request: state.builder.build(), accessToken: state.accessToken)

                await MainActor.run { // ✅ Success path (status == 200 guaranteed) // Proceed
                    self.goToLogin?() // gotoVerify?(otpType) { [weak self] in self?.goToLogin?() }
                }

            } catch let NetworkError.server(response) { // ❌ Backend error
                print("🚫 Server error:", response.message ?? "Unknown")

                response.errors?.forEach {
                    print("Field:", $0.field ?? "-", "Message:", $0.message ?? "-")
                }

                await MainActor.run {
                    self.state.errorMessage = response.message
                    self.state.fieldErrors = response.errors
                }

            } catch {
                print("❌ Registration Error:", error)

                await MainActor.run {
                    self.state.errorMessage = "Something went wrong. Please try again."
                }
            }
        }
    }
    
    // MARK: - State
    private struct State {
        var registrationType: RegistrationType
        var builder: RegistrationBuilder
        var accessToken = AppStorage.authToken?.accessToken ?? ""

        var phoneNumber: String?
        var password: String?
        var confirmPassword: String?
        var agreedToTerms: Bool
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
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
            case email = 6
            case phoneDropDown = 7
        }
    }
}
