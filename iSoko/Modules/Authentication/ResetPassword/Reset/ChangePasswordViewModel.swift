//
//  ChangePasswordViewModel.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import DesignSystemKit

@MainActor
final class ChangePasswordViewModel: FormViewModel {

    // MARK: - Navigation
    var gotoConfirm: (() -> Void)?
    var gotoLogin: (() -> Void)?

    // MARK: - Service
    private let authenticationService = NetworkEnvironment.shared.authenticationService

    // MARK: - State
    private var state: State

    // MARK: - Init
    override init() {
        self.state = State()
        super.init()
        
        Task { @MainActor in
            sections = makeSections()
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.security.rawValue,
                title: "Change Password",
                cells: [
                    headerRow,
                    currentPasswordRow,
                    newPasswordRow,
                    SpacerFormRow(tag: -1, height: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Header
    private let headerRow = TitleDescriptionFormRow(
        tag: -100,
        model: TitleDescriptionModel(
            title: "Update your password",
            description: "Enter your current password and choose a new one",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    )

    // MARK: - Rows

    private lazy var currentPasswordRow = SimpleInputFormRow(
        tag: Tags.Cells.currentPassword.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Current password",
                keyboardType: .default,
                isSecureTextEntry: true,
                returnKeyType: .done
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 6,
                maxLength: 50,
                errorMessageRequired: "Current password is required"
            ),
            useCardStyle: true,
            onTextChanged: { [weak self] text in
                self?.state.currentPassword = text
            }
        )
    )

    private lazy var newPasswordRow = SimpleInputFormRow(
        tag: Tags.Cells.newPassword.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "New password",
                keyboardType: .default,
                isSecureTextEntry: true,
                returnKeyType: .done
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 6,
                maxLength: 50,
                errorMessageRequired: "New password is required",
                errorMessageLength: "Password must be at least 6 characters"
            ),
            useCardStyle: true,
            onTextChanged: { [weak self] text in
                self?.state.newPassword = text
            }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "Update Password",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )

    // MARK: - Submit
    private func submit() async {

        guard let current = state.currentPassword,
              let new = state.newPassword else {
            showError("Please fill in all fields")
            return
        }

        guard current != new else {
            showError("New password must be different from current password")
            return
        }

        do {
            showLoader()
            defer { hideLoader() }

            let params: [String: Any] = [
                "current_password": current,
                "new_password": new
            ]

            // _ = try await authenticationService.changePassword(params)

            gotoConfirm?()

        } catch let NetworkError.server(response) {
            showError(response.message ?? "Failed to change password")

        } catch {
            showError("Something went wrong. Please try again.")
        }
    }

    // MARK: - State
    private struct State {
        var currentPassword: String?
        var newPassword: String?
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case security = 0
        }

        enum Cells: Int {
            case currentPassword = 0
            case newPassword = 1
            case submit = 2
        }
    }
}
