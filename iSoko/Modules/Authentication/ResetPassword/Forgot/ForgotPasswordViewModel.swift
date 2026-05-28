//
//  ForgotPasswordViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import DesignSystemKit
import UtilsKit
import UIKit
import StorageKit

final class ForgotPasswordViewModel: FormViewModel {
    var confirmSelection: ((OTPVerificationType) -> Void)? = { _ in }

    private var state: State?
    
    let authenticationService = NetworkEnvironment.shared.authenticationService

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
            model: TitleDescriptionModel(
                title: "Forgot password?",
                description: "Don’t worry! It happens. Please enter the email associated with your account.",
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .none,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .title,
                descriptionFontStyle: .headline
            )
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
            titleText: "common.label.email_address".localized,
            useCardStyle: true,
            onTextChanged: { [weak self] in
                self?.state?.email = $0
            }
        )
    )

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
            guard let email = self.state?.email else { return }
            self.performReset()
        }
    )

    // MARK: - Fetch
    func performReset() {
        showLoader()
        
        Task {
            let success = await performNetworkRequest()

            await MainActor.run {
                self.hideLoader()
                
                if success {
                    self.confirmSelection?(.email(address: state?.email ?? "", title: nil))
                } else {
                    print("❌ Failed to update password")
                    showError("Failed to send reset code. Please try again.")
                }
            }
        }
    }
    
    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        let parameters: [String: Any] = ["email": state?.email ?? ""]
        
        do {
            let response = try await authenticationService.passwordResetInitiate(
                parameters: parameters,
                accessToken: state?.guestToken ?? ""
            )
            
            // Check for dictionary response
            if let dict = response.asDictionary {
                if let status = dict.int(for: "status"), status >= 400 {
                    let message = dict.string(for: "message") ?? "Unknown error"
                    print("❌ Password reset failed:", message)
                    showError(message)
                    return false
                }
            }

            return true
        } catch {
            print("❌ Network error:", error.localizedDescription)
            return false
        }
    }

    // MARK: - Selection Handling

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        default:
            break
        }
    }

    // MARK: - State

    private struct State {
        var email: String?
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
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
