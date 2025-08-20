//
//  AuthViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 04/08/2025.
//

import DesignSystemKit
import UIKit

final class AuthViewModel: FormViewModel {
    
    var shouldShowTerms: Bool = false
    var hasPrimaryActionButton: Bool = false
    var hasSecondaryActionButton: Bool = false
    var buttonLayoutStyle: ButtonLayoutStyle = .horizontal
    
    var primaryButtonTitle: String = "Continue"
    var secondaryButtonTitle: String = "Cancel"
    var termsText: String = "I agree to the Terms and Conditions and Privacy Policy"
    
    var isPrimaryButtonEnabled: Bool = false {
        didSet { onPrimaryButtonStateChanged?(isPrimaryButtonEnabled) }
    }
    
    var isSecondaryButtonEnabled: Bool = true {
        didSet { onSecondaryButtonStateChanged?(isSecondaryButtonEnabled) }
    }
    
    var onPrimaryButtonStateChanged: ((Bool) -> Void)?
    var onSecondaryButtonStateChanged: ((Bool) -> Void)?
    
    var isTermsChecked: Bool = false {
        didSet { isPrimaryButtonEnabled = isTermsChecked }
    }
    //
    
    
    var gotoSignIn: (() -> Void)? = { }
    var gotoSignUp: (() -> Void)? = { }
    var gotoGuestSession: (() -> Void)? = { }
    var gotoForgotPassword: (() -> Void)? = { }
    
    private var state: State?
    
    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: -  make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(makeHeaderSection())
        sections.append(makeCredentialsSection())
        sections.append(makeQuickActionsSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                makeHeaderImageCell(),
                makeHeaderTitleRow(),
                makeGuestSessionRow(),
                makeForgotPasswordRow(),
                SpacerFormRow(tag: 1001),
                DividerFormRow(tag: 1002),
                DividerWithTextFormRow(tag: 1003, text: "OR"),
                makeSignUpRow(),
                makeSignInRow()
            ]
        )
    }
    
    private func makeCredentialsSection() -> FormSection {
        FormSection(
            id: Tags.Section.credentials.rawValue,
            title: "Credentials",
            titleStyle: FormSection.TitleStyle(
                font: .systemFont(ofSize: 18, weight: .semibold),
                color: .app(.textOnBackground)
            ),
            actionTitle: "View More",
            onActionTapped: {
                print("👀 View More tapped for credentials section")
            },
            cells: [
                makeInputPasswordRow(),
                makeInputPhoneRow(),
                makeInputRow(),
                makePhoneNumberRow()
            ]
        )
        
    }
    
    private func makeQuickActionsSection() -> FormSection {
        // Setup quick actions
        let quickActionsRow = QuickActionsFormRow(tag: 1, items: [
            QuickActionItem(
                id: "1",
                image: UIImage(systemName: "paperplane.fill") ?? UIImage(),
                imageShape: .circle,
                title: "Send Money",
                onTap: { print("Send Money tapped") }
            ),
            QuickActionItem(
                id: "2",
                image: UIImage(systemName: "tray.and.arrow.down.fill") ?? UIImage(),
                imageShape: .rounded(12),
                title: "Request",
                titleColor: .secondaryLabel,
                onTap: { print("Request tapped") }
            ),
            QuickActionItem(
                id: "3",
                image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
                imageShape: .square,
                title: "Top Up",
                onTap: { print("Top Up tapped") }
            ),
            QuickActionItem(
                id: "4",
                image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
                imageShape: .square,
                title: "Top Up",
                onTap: { print("Top Up tapped") }
            ),
            QuickActionItem(
                id: "5",
                image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
                imageShape: .square,
                title: "Top Up",
                onTap: { print("Top Up tapped") }
            ),
            QuickActionItem(
                id: "6",
                image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
                imageShape: .square,
                title: "Top Up",
                onTap: { print("Top Up tapped") }
            )
        ])
        
        return FormSection(
            id: 101,
            title: "Quick Actions",
            cells: [quickActionsRow]
        )
    }
    
    
    
    // MARK: - make rows
    private func makeHeaderImageCell() -> FormRow {
        let imageRow = ImageFormRow(tag: 1001, image: UIImage(named: "user"), height: 120)
        return imageRow
        
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Welcome to the app",
            description: "This description can be quite long and should wrap nicely without truncation dots.",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .center
        )
        
        return row
    }
    
    private func makeGuestSessionRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Submit",
            style: .primary,
            size: .large,
            icon: UIImage(systemName: "paperplane.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) {
            print("Button tapped")
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeForgotPasswordRow() -> FormRow {
        let saveButton = ButtonFormModel(
            title: "Save",
            style: .primary,
            size: .medium,
            action: { print("Save tapped") }
        )
        
        let cancelButton = ButtonFormModel(
            title: "Cancel",
            style: .outlined,
            size: .medium,
            action: { print("Cancel tapped") }
        )
        
        let buttonRow = MultiButtonFormRow(
            tag: 2001,
            model: MultiButtonFormModel(
                buttons: [cancelButton, saveButton],
                layout: .horizontal()
            )
        )
        
        let button1 = ButtonFormModel(title: "Accept", style: .primary, size: .medium, action: {
            print("Accept pressed")
        })

        let button2 = ButtonFormModel(title: "Reject", style: .secondary, size: .medium, action: {
            print("Reject pressed")
        })

        let row = TwoButtonFormRow(tag: 1, button1Model: button1, button2Model: button2, layout: .horizontal(spacing: 16, distribution: .fillProportionally))

        // This row will show two buttons in a horizontal layout.

        
        return buttonRow // buttonRow
    }
    
    private func makeSignUpRow() -> FormRow {
        let searchRow = SearchFormRow(
            tag: 3001,
            model: SearchFormModel(
                placeholder: "Search items...",
                keyboardType: .default,
                searchIcon: UIImage(systemName: "magnifyingglass"),
                searchIconPlacement: .right,
                filterIcon: UIImage(systemName: "line.horizontal.3.decrease.circle"),
                didTapSearchIcon: { print("Search icon tapped") },
                didTapFilterIcon: { print("Filter icon tapped") },
                didStartEditing: { text in print("Started editing with: \(text)") },
                didEndEditing: { text in print("Ended editing with: \(text)") },
                onTextChanged: { text in print("Search text changed: \(text)") }
            )
        )
        
        return searchRow
    }
    
    private func makeSignInRow() -> FormRow {
        let carouselModel = CarouselModel(
            items: [
                CarouselItem(image: UIImage(named: "carousel01"), text: "Offer 1", textColor: .white) { print("Tapped A") },
                CarouselItem(image: UIImage(named: "carousel02"), text: "Offer 2", textColor: .yellow) { print("Tapped B") },
                CarouselItem(image: UIImage(named: "carousel03"), text: "Offer 3", textColor: .cyan) { print("Tapped C") },
                CarouselItem(image: UIImage(named: "carousel04"), text: nil, textColor: .white) { print("Tapped D") }
            ],
            autoPlayInterval: 4,
            paginationPlacement: .inside,
            imageContentMode: .scaleAspectFill,
            transitionStyle: .fade,          // <-- Fade transition
            hideText: false,                 // <-- Set to true to hide all labels
            currentPageDotColor: .red,       // <-- Customize active dot color
            pageDotColor: .lightGray         // <-- Customize inactive dots
        )
        
        let carouselRow = CarouselRow(tag: 1001, model: carouselModel)
        
        return carouselRow
    }
    
    private func makeInputRow() -> FormRow {
        let inputModel = SimpleInputModel(
            text: "Existing value",
            config: TextFieldConfig(
                placeholder: "Enter email",
                keyboardType: .emailAddress,
                accessoryImage: UIImage(systemName: "envelope")
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 5,
                maxLength: 50,
                errorMessageRequired: "Email is required",
                errorMessageLength: "Must be 5–50 characters"
            )
        )
        
        let inputRow = SimpleInputFormRow(tag: 9001, model: inputModel)
        
        return inputRow
    }
    
    private func makeInputPhoneRow() -> FormRow {
        let inputModel = SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter phone number",
                keyboardType: .phonePad,
                accessoryImage: UIImage(systemName: "phone"),
                prefixText: "+254",
                returnKeyType: .done
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 10,
                maxLength: 13,
                errorMessageRequired: "Phone number is required",
                errorMessageLength: "Must be 10–13 digits"
            ),
            onReturnKeyTapped: {
                print("Return key tapped")
            }
        )
        
        let phoneRow = SimpleInputFormRow(tag: 9002, model: inputModel)
        
        return phoneRow
    }
    
    private func makeInputPasswordRow() -> FormRow {
        let passwordRow = SimpleInputFormRow(
            tag: 1003,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: "Enter password",
                    keyboardType: .default,
                    isSecureTextEntry: true,
                    accessoryImage: UIImage(systemName: "lock.fill"),
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
    
    private func makePhoneNumberRow() -> FormRow {
        // Create the model
        let phoneNumberModel = PhoneNumberModel()
        
        // Create the row with the model
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


extension AuthViewModel: ActionHandlingFormViewModelProtocol {
    
    var linkRanges: [NSRange: (() -> Void)] {
        let text = termsText
        let tnc = (text as NSString).range(of: "Terms and Conditions")
        let pp = (text as NSString).range(of: "Privacy Policy")
        return [
            tnc: { print("Tapped Terms") },
            pp: { print("Tapped Privacy") }
        ]
    }
    
    func handlePrimaryAction() {
        print("🚀 Primary action triggered")
    }
    
    func handleSecondaryAction() {
        print("❌ Secondary action triggered")
    }
}
