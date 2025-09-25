//
//  VerifyPasswordResetViewModel.swift
//
//
//  Created by Edwin Weru on 25/09/2025.
//

import DesignSystemKit
import UtilsKit
import UIKit

final class VerifyPasswordResetViewModel: FormViewModel {
    var confirmSelection: ((String, String) -> Void)? = { _, _ in }

    private var state: State?

    override init() {
        self.state = State()
        super.init()

        self.sections = makeSections()
    }

    // MARK: - Section Builders
    
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(FormSection(id: Tags.Section.header.rawValue, title: nil, cells: [makeHeaderTitleRow()]))
        sections.append(FormSection(id: Tags.Section.confirmation.rawValue, title: nil, cells: [passwordRow, confirmPasswordRow, SpacerFormRow(tag: -111), confirmButtonRow]))

        return sections
    }

    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Reset password",
            description: "Please type something you’ll remember",
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
            titleText: "New password",
            useCardStyle: true,
            cardStyle: .border,
            onTextChanged: { [weak self] text in
                self?.state?.password = text
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
            titleText: "Confirm password",
            useCardStyle: true,
            cardStyle: .border,
            onTextChanged: { [weak self] text in
                self?.state?.confirmPassword = text
            },
            onReturnKeyTapped: {
                print("User pressed return on password field")
            }
        )
    )

    // MARK: - Row Builders


    // MARK: - Button Row

    lazy var confirmButtonRow = ButtonFormRow(
        tag: 9999,
        model: ButtonFormModel(
            title: "Reset password",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            guard let self = self else { return }
            guard let password = self.state?.password, let confirmPassword = self.state?.confirmPassword else { return }
            self.confirmSelection?(password, confirmPassword)
        }
    )

    // MARK: - Helpers

    // MARK: - Selection Handling (optional override)

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        default:
            break
        }
    }

    // MARK: - State

    private struct State {
        var password: String?
        var confirmPassword: String?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
            case confirmation = 2
        }

        enum Cells: Int {
            case search = 0
            case email = 1
            case confirm = 2
        }
    }
}
