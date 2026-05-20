//
//  SettingsViewModel.swift
//  
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class SettingsViewModel: FormViewModel {

    // MARK: - Navigation callbacks
    var gotoContactUs: (() -> Void)?
    var gotoAboutUs: (() -> Void)?
    var gotoFAQs: (() -> Void)?
    var gotoPrivacyacyPolicy: (() -> Void)?
    var gotoTermsAndConditions: (() -> Void)?

    // MARK: - Internal state
    private var state: State

    // MARK: - Initialization
    override init() {
        state = State()
        super.init()
        sections = makeSections()
    }

    // MARK: - Sections Creation
    private func makeSections() -> [FormSection] {
        sections = [
            makeMoreOptionsSection()
        ]
        
        return sections
    }

    private func makeMoreOptionsSection() -> FormSection {
        let rows: [FormRow] = [
            makeImageTitleDescriptionRow(
                tag: 3000,
                image: UIImage(systemName: "phone.fill"),
                title: "common.help_feedback.contact_us".localized,
                description: "common.help_feedback.contact_us_description".localized,
                onTap: { [weak self] in
                    self?.gotoContactUs?()
                }
            ),

            makeImageTitleDescriptionRow(
                tag: 3001,
                image: UIImage(systemName: "info.circle.fill"),
                title: "common.help_feedback.about_us".localized,
                description: "common.help_feedback.about_us_description".localized,
                onTap: { [weak self] in
                    self?.gotoAboutUs?()
                }
            ),

            makeImageTitleDescriptionRow(
                tag: 3002,
                image: UIImage(systemName: "questionmark.circle.fill"),
                title: "common.help_feedback.faqs".localized,
                description: "common.help_feedback.faqs_description".localized,
                onTap: { [weak self] in
                    self?.gotoFAQs?()
                }
            ),

            makeImageTitleDescriptionRow(
                tag: 3003,
                image: UIImage(systemName: "lock.shield.fill"),
                title: "common.help_feedback.privacy_policy".localized,
                description: "common.help_feedback.privacy_policy_description".localized,
                onTap: { [weak self] in
                    self?.gotoPrivacyacyPolicy?()
                }
            ),

            makeImageTitleDescriptionRow(
                tag: 3004,
                image: UIImage(systemName: "doc.text.fill"),
                title: "common.help_feedback.terms_conditions".localized,
                description: "common.help_feedback.terms_conditions_description".localized,
                onTap: { [weak self] in
                    self?.gotoTermsAndConditions?()
                }
            )
        ]

        return FormSection(
            id: Tags.Section.more.rawValue,
            cells: rows
        )
    }

    // MARK: - Rows
    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage?,
        title: String,
        description: String,
        onTap: (() -> Void)? = nil
    ) -> FormRow {
        ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: image,
                imageStyle: .rounded,
                title: title,
                description: description,
                accessoryType: .image(
                    image: UIImage(named: "forwardArrowRightAligned") ?? .forwardArrow
                ),
                onTap: onTap,
                isCardStyleEnabled: true
            )
        )
    }

    // MARK: - State
    private struct State {
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case more = 0
        }
    }
}
