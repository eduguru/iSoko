//
//  OTPFormViewModel.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import DesignSystemKit
import UIKit

final class OTPFormViewModel: FormViewModel {
    var gotoTerms: (() -> Void)? = { }
    var gotoPrivacyPolicy: (() -> Void)? = { }
    var gotoConfirm: (() -> Void)? = { }
    
    private var state: State?
    
    init(verificationNumber: String) {
        self.state = State(verificationNumber: verificationNumber)
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: -  make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(makeHeaderSection())
        sections.append(makeNamesSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [ makeHeaderTitleRow()]
        )
    }
    
    private func makeNamesSection() -> FormSection {
        FormSection(
            id: Tags.Section.names.rawValue,
            title: nil,
            cells: [
                SpacerFormRow(tag: -00001),
                otpRow,
                SpacerFormRow(tag: -00001),
                continueButtonRow
            ]
        )
    }
    
    // MARK: - make rows
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: -101,
            title: "Enter the code",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
        
        return row
    }
    
    lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
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
    
    lazy var otpRow = OTPRow(
        tag: 1001,
        config: OTPRowConfig(
            numberOfDigits: 6,
            sentMessage: "We’ve sent a code to \(state?.verificationNumber ?? "unknown number")",
            showResendTimer: true,
            resendDuration: 30,
            keyboardType: .numberPad,
            onOTPComplete: { otp in
                print("✅ Entered OTP: \(otp)")
                // Here you can verify the OTP or trigger next step
            },
            onResendTapped: {
                print("🔄 Resend tapped!")
                // Trigger resend logic here
            }
        )
    )
    
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
    
    
    // MARK: - selection
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        default:
            break
        }
    }
    
    
    private struct State {
        var verificationNumber: String
        var firstName: String?
        var lastName: String?
        var gender: String?
        var ageRange: CommonIdNameModel?
        var roles: CommonIdNameModel?
        var location: LocationModel?
        var referralCode: String?
    }
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case names = 1
            case gender = 2
            case roles = 3
        }
        
        enum Cells: Int {
            case title = 0
            case firstName = 1
            case lastName = 2
            case male = 3
            case female = 4
            case ageRange = 5
            case roles = 6
            case location = 7
            case referralCode = 9
            case submit = 10
        }
    }
}
