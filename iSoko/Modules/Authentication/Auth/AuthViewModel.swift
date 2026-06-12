//
//  AuthViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 04/08/2025.
//

import DesignSystemKit
import UIKit
import StorageKit

final class AuthViewModel: FormViewModel {
    var gotoSignIn: ((_ verifier: String) -> Void)?
    var goToExchangeToken: ((_ code: String) -> Void)?
    var goToGetUserDetails: (() -> Void)?

    
    var gotoSignUp: ((_ builder: RegistrationBuilder) -> Void)? = { _ in }
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
                makeHeaderImageCell(),
                SpacerFormRow(tag: 1001, height: 32),
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
            actionTitle: "common.auth_view.view_more".localized,
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
                height: 80
            )
        )
        return imageRow
        
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            model: TitleDescriptionModel(
            title: "Welcome to iSOKO", // "common.auth_view.sign_in_title".localized,
            description: "Join a network of Traders and grow your business.",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .center,
            titleFontStyle: .title,
            descriptionFontStyle: .subheadline
        )
        )
        
        return row
    }
    
    private func makeLoginButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "common.auth_view.sign_in_title".localized,
            style: .primary,
            size: .medium,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            // This block will be called when the user taps the "common.auth_view.sign_in_title".localized button
            self?.gotoSignIn?(self?.state?.verifier ?? "")
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }

    private func makeForgotPasswordButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "common.auth_view.forgot_password".localized,
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
            title: "common.auth_view.create_account".localized,
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
                guard let self, let state else { return }
                self.gotoSignUp?(state.registrationBuilder)
            }
        )
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    private func makeGuestButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "common.auth_view.guest_mode".localized,
            style: .custom(
                backgroundColor: .clear,
                textColor: .app(.hex("#717171")),
                borderColor: .app(.hex("#D9D9D9")),
                cornerRadius: 10
            ),
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoGuestSession?()
        }

        return ButtonFormRow(tag: 1001, model: buttonModel)
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
        var registrationBuilder: RegistrationBuilder = RegistrationBuilder()
        var verifier = AppStorage.verifier ?? ""
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
