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
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                SpacerFormRow(tag: 1001),
//                makeHeaderImageCell(),
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
                makeSignUpButtonRow(),
                makeGuestButtonRow()
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
            title: "Sign in",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
        
        return row
    }
    
    private func makeLoginButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Sign in",
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
