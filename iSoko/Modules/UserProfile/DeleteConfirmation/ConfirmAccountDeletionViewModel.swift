//
//  ConfirmAccountDeletionViewModel.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import DesignSystemKit
import Foundation
import StorageKit

@MainActor
final class ConfirmAccountDeletionViewModel: FormViewModel {

    // MARK: - Navigation
    var gotoConfirm: ((_ title: String, _ message: String?, _ onConfirm: @escaping (Bool) -> Void) -> Void)?
    var goToLogin: (() -> Void)?

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
                id: Tags.Section.main.rawValue,
                cells: [
                    titleFormRow,
                    SpacerFormRow(tag: -1, height: 20),
                    descriptionRow,
                    SpacerFormRow(tag: -1, height: 12),
                    passwordRow,
                    SpacerFormRow(tag: -1, height: 20),
                    deleteButtonRow
                ]
            )
        ]
    }

    // MARK: - TITLE ROW (your provided pattern adapted)
    private lazy var titleFormRow: FormRow = makeTitleRow(
        title: "Delete Account",
        description: "This action is permanent. Enter your password and optionally tell us why you're leaving."
    )

    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: UUID().hashValue,
            model: TitleDescriptionModel(
                title: title,
                description: description,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .headline,
                descriptionFontStyle: .subheadline
            )
        )
    }

    // MARK: - PASSWORD FIELD
    private lazy var passwordRow = SimpleInputFormRow(
        tag: Tags.Cells.password.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Enter password to confirm",
                keyboardType: .default,
                isSecureTextEntry: true,
                returnKeyType: .done
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 6,
                maxLength: 50,
                errorMessageRequired: "Password is required"
            ),
            useCardStyle: true,
            onTextChanged: { [weak self] text in
                self?.state.password = text
            }
        )
    )

    // MARK: - DESCRIPTION ROW (reason for deletion)
    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: Tags.Cells.description.rawValue,
        model: LongInputDescriptionModel(
            text: state.description ?? "",
            config: TextViewConfig(fixedHeight: 120),
            validation: ValidationConfiguration(isRequired: false),
            titleText: "Reason (optional)",
            onTextChanged: { [weak self] text in
                self?.state.description = text
            }
        )
    )

    // MARK: - BUTTON
    private lazy var deleteButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "Delete Account",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )

    // MARK: - Submit
    private func submit() {
        guard let password = state.password, !password.isEmpty else {
            showError("Password is required")
            return
        }

        gotoConfirm?("Delete account", "Are you sure you want to delete your account?") { [weak self] confirmed in
            guard let self else { return }
            guard confirmed else { return }

            self.performDeletion()
        }
    }
    
    private func performDeletion() {
        let password = state.password ?? ""

        Task { @MainActor in
            do {
                showLoader()
                defer { hideLoader() }

                let params: [String: Any] = [
                    "password": password,
                    "reason": state.description ?? ""
                ]

                _ = try await authenticationService.deleteUserProfile(
                    id: state.userProfile?.id ?? 0,
                    parameters: params,
                    accessToken: state.oauthToken
                )

                goToLogin?()

            } catch let NetworkError.server(response) {
                showError(response.message ?? "Failed to delete account")

            } catch {
                showError("Something went wrong. Please try again.")
            }
        }
    }

    // MARK: - State
    private struct State {
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var userDetail: UserDetails? = AppStorage.userDetail
        var userProfile: UserProfileResponse? = AppStorage.userProfile
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
        
        var password: String?
        var description: String?
        
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case main = 0
        }

        enum Cells: Int {
            case password = 0
            case description = 1
            case submit = 2
        }
    }
}
