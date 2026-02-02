//
//  SignUpOptionsViewModel.swift
//
//
//  Created by Edwin Weru on 07/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit
import NetworkingKit

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
    
    let authenticationService = NetworkEnvironment.shared.authenticationService

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
        state.registrationBuilder.phoneNumberCountry = IDNamePairInt(id: Int(newCountry.id) ?? 0, name: newCountry.name)
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
                // Get phone number and country code
                let phone = self.phoneDropDownRow.model.phoneNumber.trimmingCharacters(in: .whitespaces)
                let countryCode = self.phoneDropDownRow.model.selectedCountry.phoneCode
                
                // Combine country code with local number to form full phone number
                let fullPhoneNumber = "\(countryCode)\(phone)"
                
                // Validate the full phone number
                if !fullPhoneNumber.isValidPhoneNumber() {
                    self.showErrorMessage("Please enter a valid phone number.")
                    return
                }
                
                _ = self.preValidatePhone(fullPhoneNumber)
                
            } else {
                // Validate email
                let email = self.emailInputRow.model.text.trimmingCharacters(in: .whitespaces)
                if !email.isValidEmail() {
                    self.showErrorMessage("Please enter a valid email address.")
                    return
                }
                
                _ = self.preValidateEmail(email)
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

    //MARK: - funcs
    private func toggleEmailPhoneInput() {
        state.isUsingPhone.toggle()
        emailButtonRow.model = makeEmailButtonModel()
        self.sections = makeSections()
        onReloadData?()
    }
    
    private func showErrorMessage(_ message: String) {
        print("⚠️ Pre-Validation Error: \(message)")
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
    
    //MARK: - calls
    private func preValidatePhone(_ phone: String) -> Task<Void, Never> {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                let response = try await authenticationService.preValidatePhone(
                    phone,
                    accessToken: state.accessToken
                )

                // ✅ Success path (status == 200 guaranteed)
                await MainActor.run {
                    // Proceed to OTP screen if phone is valid
                    self.goToOtp?(.phone(number: phone, title: "Verify your phone")) { [weak self] in
                        guard let self = self else { return }
                        self.goToCompleteProfile?(self.state.registrationBuilder)
                    }
                }

            } catch let NetworkError.server(response) {
                // ❌ Backend error
                print("🚫 Server error:", response.message ?? "Unknown")

                response.errors?.forEach {
                    print("Field:", $0.field ?? "-", "Message:", $0.message ?? "-")
                }

                await MainActor.run {
                    self.state.errorMessage = response.message
                    self.state.fieldErrors = response.errors
                }

            } catch {
                // ❌ Network / decoding / unexpected
                print("❌ Error:", error)

                await MainActor.run {
                    self.state.errorMessage = "Something went wrong. Please try again."
                }
            }
        }
    }
    
    private func preValidateEmail(_ email: String) -> Task<Void, Never> {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                let response = try await authenticationService.preValidateEmail(
                    email,
                    accessToken: state.accessToken
                )

                // ✅ Success (status == 200 guaranteed)
                await MainActor.run {
                    self.goToOtp?(.email(address: email, title: "Verify your email")) { [weak self] in
                        guard let self = self else { return }
                        self.goToCompleteProfile?(self.state.registrationBuilder)
                    }
                }

            } catch let NetworkError.server(response) {
                // ❌ Backend error
                print("🚫 Server error:", response.message ?? "Unknown")

                response.errors?.forEach {
                    print("Field:", $0.field ?? "-", "Message:", $0.message ?? "-")
                }

                await MainActor.run {
                    self.state.errorMessage = response.message
                    self.state.fieldErrors = response.errors
                }

            } catch {
                // ❌ Network / decoding / unexpected
                print("❌ Error:", error)

                await MainActor.run {
                    self.state.errorMessage = "Something went wrong. Please try again."
                }
            }
        }
    }

    // MARK: Nested Types
    private struct State {
        var registrationBuilder: RegistrationBuilder
        var isUsingPhone: Bool = false
        var email: String?
        var phoneNumber: String?
        var accessToken = AppStorage.authToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
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
