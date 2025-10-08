//
//  OTPFormViewModel.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import DesignSystemKit
import UIKit

final class OTPFormViewModel: FormViewModel {

    // MARK: - Callbacks

    var gotoTerms: (() -> Void)?
    var gotoPrivacyPolicy: (() -> Void)?
    var gotoConfirm: (() -> Void)?
    var onResendCode: (() -> Void)?
    var onOTPComplete: ((String) -> Void)?

    // MARK: - State

    private var state: State

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
            title: state.type.displayTitle,
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    }

    lazy var otpRow: OTPRow = {
        OTPRow(
            tag: Tags.Cells.otp.rawValue,
            config: OTPRowConfig(
                numberOfDigits: 6,
                sentMessage: "We’ve sent a code to \(state.type.targetValue)",
                showResendTimer: true,
                resendDuration: 30,
                keyboardType: .numberPad,
                onOTPComplete: { [weak self] otp in
                    print("✅ Entered OTP: \(otp)")
                    self?.onOTPComplete?(otp)
                },
                onResendTapped: { [weak self] in
                    print("🔄 Resend tapped!")
                    self?.onResendCode?()
                }
            )
        )
    }()

    lazy var continueButtonRow: ButtonFormRow = {
        ButtonFormRow(
            tag: Tags.Cells.continueButton.rawValue,
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
    }()

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

    // MARK: - Selection

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        // Add selection logic here if needed
    }

    // MARK: - Internal State

    private struct State {
        var type: OTPVerificationType
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case otp = 1
        }

        enum Cells: Int {
            case headerTitle = 100
            case spacerTop = 101
            case spacerBottom = 102
            case otp = 103
            case continueButton = 104
        }
    }
}
