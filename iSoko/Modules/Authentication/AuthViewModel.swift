//
//  AuthViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 04/08/2025.
//

import DesignSystemKit
import UIKit

final class AuthViewModel: FormViewModel {
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
        sections.append(FormSection(id: -111, cells: [faceIDRow, notificationsRow, countryRow]))
        
        sections.append(
        
            FormSection(id: 0, title: "User Info", cells: [
                DropdownFormRow(
                    tag: 101,
                    config: DropdownFormConfig(
                        title: "Country",
                        placeholder: "Choose a country",
                        subtitle: nil,
                        leftImage: UIImage(systemName: "globe"),
                        rightImage: UIImage(systemName: "chevron.down"),
                        isCardStyleEnabled: true,
                        onTap: {
                            print("Tapped Country")
                        }
                    )
                ),
                DropdownFormRow(
                    tag: 102,
                    config: DropdownFormConfig(
                        title: nil,
                        placeholder: "Choose a city",
                        subtitle: nil,
                        leftImage: nil,
                        rightImage: UIImage(systemName: "chevron.right"),
                        isCardStyleEnabled: true,
                        cardBackgroundColor: .systemGray6,
                        onTap: {
                            print("Tapped City")
                        }
                    )
                )
            ])


            
        )
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                makeHeaderImageCell(),
                makeHeaderTitleRow(),
                SpacerFormRow(tag: 1001),
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
                SpacerFormRow(tag: 1001),
                makeLoginButtonRow(),
                makeForgotPasswordButtonRow(),
                DividerWithTextFormRow(tag: 1003, text: ""),
                SpacerFormRow(tag: 1001),
                makeSignUpButtonRow(),
                DividerWithTextFormRow(tag: -1, text: "OR"),
                makeGuestButtonRow()
            ]
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
    
    private func makeLoginButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Login",
            style: .primary,
            size: .medium,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoSignIn?()
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeForgotPasswordButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Forgot your Password",
            style: .plain,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoForgotPassword?()
        }

        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeSignUpButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Create an Account",
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
                self?.gotoSignUp?()
            }
        )
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeGuestButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Guest Mode",
            style: .secondary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoGuestSession?()
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    let faceIDRow = SelectableRow(
        tag: 1001,
        config: SelectableRowConfig(
            title: "Enable Face ID",
            description: "Use Face ID for secure login",
            isSelected: true,
            selectionStyle: .checkbox, // or .radio
            isAccessoryVisible: true,
            accessoryImage: UIImage(systemName: "faceid"),
            isCardStyleEnabled: true,
            cardCornerRadius: 12,
            cardBackgroundColor: .secondarySystemGroupedBackground,
            cardBorderColor: UIColor.systemGray4,
            cardBorderWidth: 1,
            onToggle: { isSelected in
                print("Face ID enabled: \(isSelected)")
            }
        )
    )

    let notificationsRow = SelectableRow(
        tag: 1002,
        config: SelectableRowConfig(
            title: "Push Notifications",
            description: "Get notified about new messages",
            isSelected: false,
            selectionStyle: .radio,
            isAccessoryVisible: false,
            isCardStyleEnabled: true,
            onToggle: { isSelected in
                print("Notifications selected: \(isSelected)")
            }
        )
    )
    
    lazy var countryRow = DropdownFormRow(
        tag: 3001,
        config: DropdownFormConfig(
            title: "Country",
            placeholder: "Select your country",
            leftImage: UIImage(systemName: "globe"),
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.presentCountryPicker()
            }
        )
    )

    private func presentCountryPicker() {
        let countries = ["USA", "Canada", "Germany"]
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
