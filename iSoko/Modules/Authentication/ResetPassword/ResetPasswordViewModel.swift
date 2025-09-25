//
//  ResetPasswordViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import DesignSystemKit
import UtilsKit
import UIKit

final class ResetPasswordViewModel: FormViewModel {
    var confirmSelection: ((String) -> Void)? = { _ in }

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
        sections.append(FormSection(id: Tags.Section.confirmation.rawValue, title: nil, cells: [emailInputRow, SpacerFormRow(tag: -111), confirmButtonRow]))

        return sections
    }

    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Forgot password?",
            description: "Don’t worry! It happens. Please enter the email associated with your account.",
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
                self?.state?.email = $0
            }
        )
    
    )

    // MARK: - Row Builders


    // MARK: - Button Row

    lazy var confirmButtonRow = ButtonFormRow(
        tag: 9999,
        model: ButtonFormModel(
            title: "Send code",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            guard let self = self else { return }
            guard let selected = self.state?.email else { return }
            self.confirmSelection?(selected)
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
        var email: String?
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
