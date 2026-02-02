//
//  LoginViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import DesignSystemKit
import UIKit
import StorageKit

final class LoginViewModel: FormViewModel {
    
    var gotoConfirm: (() -> Void)? = { }
    var gotoSignIn: (() -> Void)? = { }
    var gotoForgotPassword: (() -> Void)? = { }
    
    private var state: State?
    
    let certificateService = NetworkEnvironment.shared.certificateService
    let authenticationService = NetworkEnvironment.shared.authenticationService
    let userDetailsService = NetworkEnvironment.shared.userDetailsService
    let commonUtilitiesService = NetworkEnvironment.shared.commonUtilitiesService
    
    private func getToken() {
        Task {
            do {
                
                    let token = try await authenticationService.login(
                        grant_type: AppConstants.GrantType.login.rawValue,
                        client_id: ApiEnvironment.clientId,
                        client_secret: ApiEnvironment.clientSecret,
                        username: "+254712270408",
                        password: "12345678"
                    )

                print("🔑 Logged in with token:", token.accessToken)
                AppStorage.authToken = token
                
                let response = try await userDetailsService.getUserDetails(accessToken: token.accessToken)
                if let response = response {
                    print("User Details: \(response)")
                } else {
                    print("No user details returned")
                }
                
                let respo = try await commonUtilitiesService.getAllLocations(page: 1, count: 10, accessToken: token.accessToken)
                print("respo returned: \(respo) \(respo.count)")
                

            } catch let NetworkError.server(apiError) {
                // ❌ API returned error body
                print("API error:", apiError.message ?? "")
            } catch {
                // ❌ Networking/decoding
                print("Unexpected error:", error)
            }
        }
    }
    
    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
        
        getToken()

    }
    
    // MARK: -  make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(makeHeaderSection())
        sections.append(makeCredentialsSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                makeHeaderImageCell(),
                makeHeaderTitleRow(),
                SpacerFormRow(tag: 1001)
            ]
        )
    }
    
    private func makeCredentialsSection() -> FormSection {
        FormSection(
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
            cells: [
                makeEmailInputRow(),
//                makePhoneNumberInputRow(),
                makePasswordInputRow(),
                SpacerFormRow(tag: 1001),
                makeLoginButtonRow(),
                makeForgotPasswordButtonRow()
            ]
        )
        
    }
    
    // MARK: - make rows
    private func makeHeaderImageCell() -> FormRow {
        let imageRow = ImageFormRow(
            tag: 1,
            config: .init(
                image: UIImage(named: "logo"),
                height: 120
            )
        )
        return imageRow
        
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Welcome to the app",
            description: "This description",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .center
        )
        
        return row
    }
    
    private func makeOptionsSegmentFormRow() -> FormRow {
        let styledSegmentRow = SegmentedFormRow(
            model: SegmentedFormModel(
                title: "Login With",
                segments: ["Email", "Phone Number"],
                selectedIndex: 0,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { selectedIndex in
                    print("Segment changed to index: \(selectedIndex)")
                }
            ))
        
        return styledSegmentRow
    }
    
    private func makeForgotPasswordButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Forgot your Password",
            style: .plain,
            size: .large,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) {
            print("Button tapped")
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeLoginButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Login",
            style: .primary,
            size: .large,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeEmailInputRow() -> FormRow {
        let inputModel = SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter email",
                keyboardType: .emailAddress,
                accessoryImage: nil //UIImage(systemName: "envelope")
                
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 5,
                maxLength: 50,
                errorMessageRequired: "Email is required",
                errorMessageLength: "Must be 5–50 characters"
            ),
            useCardStyle: true
        )
        
        let inputRow = SimpleInputFormRow(tag: 9001, model: inputModel)
        
        return inputRow
    }
    
    private func makePasswordInputRow() -> FormRow {
        let passwordRow = SimpleInputFormRow(
            tag: 1003,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: "Enter password",
                    keyboardType: .default,
                    isSecureTextEntry: true,
                    accessoryImage: nil,
                    returnKeyType: .done,
                    autoCapitalization: .none,
                    textContentType: .password
                ),
                validation: ValidationConfiguration(
                    isRequired: true,
                    minLength: 6,
                    maxLength: 20,
                    errorMessageRequired: "Password is required",
                    errorMessageLength: "Password must be 6–20 characters"
                ),
                useCardStyle: true,
                onTextChanged: { text in
                    print("Password updated: \(text)")
                },
                onReturnKeyTapped: {
                    print("User pressed return on password field")
                }
            )
        )
        
        return passwordRow
    }
    
    private func makePhoneNumberInputRow() -> FormRow {
        let phoneNumberModel = PhoneNumberModel()
        let phoneNumberRow = PhoneNumberRow(tag: 1, model: phoneNumberModel)
        
        return phoneNumberRow
    }
    
    //    func validateForm() {
    //        if phoneNumberRow.validateWithError() {
    //            // Form is valid
    //        } else {
    //            // Show validation error
    //        }
    //    }
    
    // MARK: - selection
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
            // Handle header taps here
        case Tags.Section.credentials.rawValue:
            print("Credentials section row selected: \(row.tag)")
            // Handle credentials taps here
        default:
            break
        }
    }
    
    private struct State {
        
    }
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case credentials = 1
        }
        
        enum Cells: Int {
            case signIn = 0
            case forgotPassword = 1
            case register = 2
            case guest = 3
            case divideLine = 4
            case headerImage = 5
            case headerTitle = 6
        }
    }
}
