//
//  SignupOTPViewModel.swift
//  
//
//  Created by Edwin Weru on 18/05/2026.
//

import DesignSystemKit
import UIKit
import StorageKit

@MainActor
final class SignupOTPViewModel: FormViewModel {

    // MARK: - Callbacks
    var onResendCode: (() -> Void)?
    var onOTPVerified: (() -> Void)?  // Called after successful verification, to navigate to complete profile
    var onOTPFailure: ((String) -> Void)?

    // MARK: - State
    private var state: State
    let authenticationService = NetworkEnvironment.shared.authenticationService

    // MARK: - Init
    init(type: OTPVerificationType) {
        self.state = State(type: type)
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Section Builders
    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeOTPSection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [makeHeaderTitleRow()]
        )
    }

    private func makeOTPSection() -> FormSection {
        FormSection(
            id: Tags.Section.otp.rawValue,
            title: nil,
            cells: [
                SpacerFormRow(tag: Tags.Cells.spacerTop.rawValue),
                otpRow,
                SpacerFormRow(tag: Tags.Cells.spacerBottom.rawValue),
                continueButtonRow
            ]
        )
    }

    // MARK: - Row Builders
    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            model: TitleDescriptionModel(
                title: state.type.displayTitle,
                description: "",
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .none,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left
            )
        )
    }

    lazy var otpRow: OTPRow = {
        OTPRow(
            tag: Tags.Cells.otp.rawValue,
            config: OTPRowConfig(
                numberOfDigits: 5,
                sentMessage: "We’ve sent a code to \(state.type.targetValue)",
                showResendTimer: true,
                resendDuration: 30,
                keyboardType: .numberPad,
                onOTPComplete: { [weak self] otp in
                    self?.state.otp = otp
                    Task { await self?.verifyOtp(otp: otp) }
                },
                onResendTapped: { [weak self] in
                    self?.onResendCode?()
                }
            )
        )
    }()

    lazy var continueButtonRow: ButtonFormRow = {
        ButtonFormRow(
            tag: Tags.Cells.continueButton.rawValue,
            model: ButtonFormModel(
                title: "common.button.continue".localized,
                style: .primary,
                size: .medium,
                icon: nil,
                fontStyle: .headline,
                hapticsEnabled: true
            ) { [weak self] in
                guard let self = self else { return }
                let otp = self.state.otp
                Task { await self.verifyOtp(otp: otp) }
            }
        )
    }()

    // MARK: - OTP Verification
    @MainActor
    func verifyOtp(otp: String) async {
        showLoader()
        defer { hideLoader() }

        let parameters: [String: Any] = [
            "contact": state.type.targetValue,
            "otp": otp
        ]

        do {
            let response = try await authenticationService.verifyAccountOTP(
                parameters: parameters,
                accessToken: state.guestToken
            )

            if let dict = response.asDictionary, let message = dict["message"]?.asString {
                print("✅ OTP Verified: \(message)")
                
                // Navigate to complete profile only on "Email verified"
                if message.lowercased().contains("email verified") {
                    onOTPVerified?()
                } else {
                    onOTPFailure?("OTP verification succeeded, but unexpected message: \(message)")
                    showError("Unexpected message: \(message)")
                }

            } else {
                onOTPFailure?("Unexpected response from server.")
                showError("Unexpected response from server.")
            }

        } catch {
            onOTPFailure?("OTP verification failed: \(error.localizedDescription)")
            showError("OTP verification failed: \(error.localizedDescription)")
        }
    }

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

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {}

    // MARK: - Internal State
    private struct State {
        var type: OTPVerificationType
        var otp: String = ""

        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int { case header = 0, otp = 1 }
        enum Cells: Int {
            case headerTitle = 100
            case spacerTop = 101
            case spacerBottom = 102
            case otp = 103
            case continueButton = 104
        }
    }
}
