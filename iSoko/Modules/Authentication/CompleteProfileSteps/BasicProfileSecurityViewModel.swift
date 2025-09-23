//
//  BasicProfileSecurityViewModel.swift
//
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit

final class BasicProfileSecurityViewModel: FormViewModel {
    var gotoTerms: (() -> Void)? = { }
    var gotoPrivacyPolicy: (() -> Void)? = { }
    var gotoConfirm: (() -> Void)? = { }
    
    private var state: State?
    
    let fullText = "You acknowledge you have read and agreed to our terms of use and privacy policy"
    lazy var termsRange: NSRange = {
        (fullText as NSString).range(of: "terms of use")
    }()
    
    lazy var privacyRange: NSRange = {
        (fullText as NSString).range(of: "privacy policy")
    }()
    
    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: -  make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(makeHeaderSection())
        sections.append(makeNamesSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [ makeHeaderTitleRow(), phoneNumberRow]
        )
    }
    
    private func makeNamesSection() -> FormSection {
        FormSection(
            id: Tags.Section.names.rawValue,
            title: "Set Your Password",
            cells: [ passwordRow, confirmPasswordRow, requirementsListRow, termsRow, SpacerFormRow(tag: -00001), continueButtonRow]
        )
    }
    
    // MARK: - make rows
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: -101,
            title: "Verify your phone number",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
        
        return row
    }
    
    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
    )
    
    lazy var phoneNumberRow = PhoneNumberRow(
        tag: 1,
        model: PhoneNumberModel()
    )
    
    lazy var passwordRow = SimpleInputFormRow(
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
            cardStyle: .border,
            onTextChanged: { text in
                print("Password updated: \(text)")
            },
            onReturnKeyTapped: {
                print("User pressed return on password field")
            }
        )
    )
    
    lazy var confirmPasswordRow = SimpleInputFormRow(
        tag: 1003,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Confirm password",
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
            cardStyle: .border,
            onTextChanged: { text in
                print("Password updated: \(text)")
            },
            onReturnKeyTapped: {
                print("User pressed return on password field")
            }
        )
    )
    
    // Create a config with your preferences
    let config = RequirementsListRowConfig(
        title: "Password Requirements",
        items: [
            RequirementItem(title: "Must be at least 8 characters", isSatisfied: true),
            RequirementItem(title: "Include a number", isSatisfied: true),
            RequirementItem(title: "Include a special character", isSatisfied: true)
        ],
        titleColor: .app(.primary),        // configurable title color
        itemColor: .label,              // configurable item text color
        selectionStyle: .checkbox,      // or .dot
        isCardStyleEnabled: true,       // card background with rounded corners
        cardCornerRadius: 12,
        cardBackgroundColor: .systemGray6,
        cardBorderColor: .systemGray3,
        cardBorderWidth: 1,
        spacing: 10,
        contentInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    )

    // Initialize your RequirementsListRow
    lazy var requirementsListRow = RequirementsListRow(tag: 1, config: config)

    lazy var termsRow = TermsCheckboxRow(
        tag: 300,
        config: TermsCheckboxRowConfig(
            isAgreed: false,
            descriptionText: fullText,
            termsLinkRange:termsRange,
            privacyLinkRange: privacyRange,
            onToggle: { agreed in
                print("Agreed? \(agreed)")
            },
            onTermsTapped: { print("Terms tapped") },
            onPrivacyTapped: { print("Privacy tapped") },
            checkboxTintColor: .app(.primary),
            useCardStyle: true
        )
    )
    
    // MARK: - Helpers
    
    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                break
            }
        }
    }
    
    
    // MARK: - selection
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        default:
            break
        }
    }
    
    
    private struct State {
        var firstName: String?
        var lastName: String?
        var gender: String?
        var ageRange: CommonIdNameModel?
        var roles: CommonIdNameModel?
        var location: LocationModel?
        var referralCode: String?
    }
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case names = 1
            case gender = 2
            case roles = 3
        }
        
        enum Cells: Int {
            case title = 0
            case firstName = 1
            case lastName = 2
            case male = 3
            case female = 4
            case ageRange = 5
            case roles = 6
            case location = 7
            case referralCode = 9
            case submit = 10
        }
    }
}
