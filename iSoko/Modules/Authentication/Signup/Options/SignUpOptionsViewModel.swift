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

@MainActor
final class SignUpOptionsViewModel: FormViewModel {

    // MARK: - Callbacks
    var goToContinue: (() -> Void)? = { }
    var goBack: (() -> Void)? = { }
    var goToOtp: ((_ builder: RegistrationBuilder, OTPVerificationType, _ onSuccess: (() -> Void)?) -> Void)? = { _, _, _ in }
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
        
        Task { @MainActor in
            self.sections = self.makeSections()
        }
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
                SpacerFormRow(tag: Tags.Cells.spacer2.rawValue)
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
            // googleButtonRow
        ]
        
        return FormSection(
            id: Tags.Section.credentials.rawValue,
            title: nil,
            titleStyle: FormSection.TitleStyle(
                font: .systemFont(ofSize: 18, weight: .semibold),
                color: .app(.textOnBackground)
            ),
            actionTitle: "common.auth_view.view_more".localized,
            onActionTapped: {
                print("👀 View More tapped for credentials section")
            },
            cells: cells
        )
    }

    // MARK: - Row Builders

    lazy var emailInputRow: SimpleInputFormRow = {
        var model = SimpleInputModel(
            text: state.email ?? "",
            config: TextFieldConfig(
                placeholder: "common.label.email_address".localized,
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

    lazy var phoneDropDownRow: PhoneDropDownFormRow = { [weak self] in
        guard let self = self else { fatalError("Self is nil") }
        let iso = AppStorage.selectedRegion?.capitalized ?? "KE"
        let selectedCountry: Country = countryHelper.country(forISO: iso)
            ?? countryHelper.defaultCountry
            ?? Country(id: "KE", name: "Kenya", phoneCode: "+254", continentCode: "AF")
        
        return PhoneDropDownFormRow(
            tag: Tags.Cells.phoneDropDown.rawValue,
            model: PhoneDropDownModel(
                phoneNumber: state.phoneNumber ?? "",
                selectedCountry: selectedCountry,
                placeholder: "common.basic_profile_security.phone_placeholder".localized,
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
                    self.state.phoneNumber = "\(selectedCountry.phoneCode)\(new)"
                    self.state.registrationBuilder.phoneNumber = new
                },
                onCountryTapped: { [weak self] in
                    self?.showCountryPicker? { selectedCountry in
                        self?.updatePhoneCountry(selectedCountry)
                    }
                },
                onValidationError: { [weak self] err in
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
    }

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            model: TitleDescriptionModel(
                title: "common.auth_view.create_account".localized,
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
        )
    }

    // MARK: - Continue Button
    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.continueButton.rawValue,
        model: ButtonFormModel(
            title: "common.button.continue".localized,
            style: .primary,
            size: .medium,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            guard let self = self else { return }
            
            Task {
                if self.state.isUsingPhone {
                    let phone = self.phoneDropDownRow.model.phoneNumber.trimmingCharacters(in: .whitespaces)
                    let countryCode = self.phoneDropDownRow.model.selectedCountry.phoneCode
                    let fullPhoneNumber = "\(countryCode)\(phone)"
                    
                    if !fullPhoneNumber.isValidPhoneNumber() {
                        self.showErrorMessage("Please enter a valid phone number.")
                        return
                    }
                    _ = await self.preValidatePhone(fullPhoneNumber)
                    
                } else {
                    let email = self.emailInputRow.model.text.trimmingCharacters(in: .whitespaces)
                    if !email.isValidEmail() {
                        self.showErrorMessage("Please enter a valid email address.")
                        return
                    }
                    _ = await self.preValidateEmail(email)
                }
            }
        }
    )

    // MARK: - Email / Google Buttons
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

    // MARK: - Navigation Bar
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
    
    private func showErrorMessage(_ message: String) {
        print("Error: \(message)")
        showError(message)
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

    // MARK: - Availability & OTP
    private func preValidateEmail(_ email: String) async -> Bool {
        showLoader()
        defer { hideLoader() }

        let parameters: [String: Any] = ["email": email]

        do {
            let response = try await authenticationService.userAvailabilityCheck(
                parameters: parameters,
                accessToken: state.guestToken
            )

            if let dict = response.asDictionary, let available = dict["available"]?.asBool {
                if available {
                    showErrorMessage("Email already exists.")
                    return false
                } else {
                    await initiateOtp(for: email)
                    return true
                }
            } else {
                showErrorMessage("Unexpected response from server.")
                return false
            }
        } catch {
            showErrorMessage("Network error: \(error.localizedDescription)")
            return false
        }
    }

    private func preValidatePhone(_ fullPhone: String) async -> Bool {
        showLoader()
        defer { hideLoader() }

        let parameters: [String: Any] = ["phoneNumber": fullPhone]

        do {
            let response = try await authenticationService.userAvailabilityCheck(
                parameters: parameters,
                accessToken: state.guestToken
            )

            if let dict = response.asDictionary, let available = dict["available"]?.asBool {
                if available {
                    showErrorMessage("Phone already exists.")
                    return false
                } else {
                    await initiateOtp(for: fullPhone, type: "sms")
                    return true
                }
            } else {
                showErrorMessage("Unexpected response from server.")
                return false
            }
        } catch {
            showErrorMessage("Network error: \(error.localizedDescription)")
            return false
        }
    }

    private func initiateOtp(for contact: String, type: String = "email") async {
        let parameters: [String: Any] = [
            "contact": contact,
            "intent": "pre_registration",
            "type": type
        ]

        do {
            _ = try await authenticationService.accountVerificationOTP(
                parameters: parameters,
                accessToken: state.guestToken
            )

            goToOtp?(
                state.registrationBuilder, 
                type == "email" ? .email(address: contact, title: nil) : .phone(number: contact, title: nil),
                nil
            )
        } catch {
            showErrorMessage("Failed to initiate OTP: \(error.localizedDescription)")
        }
    }

    // MARK: - State
    private struct State {
        var registrationBuilder: RegistrationBuilder
        var isUsingPhone: Bool = false
        var email: String?
        var phoneNumber: String?
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int { case header = 0, credentials = 1 }
        enum Cells: Int {
            case spacer1 = 1001, spacer2 = 1002
            case emailInput = 1003, continueButton = 1004
            case emailButton = 1005, googleButton = 1006
            case headerTitle = 101, phoneDropDown = 9100
            case divider = -1
        }
    }
}
