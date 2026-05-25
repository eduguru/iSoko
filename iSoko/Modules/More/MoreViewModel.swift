//
//  MoreViewModel.swift
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class MoreViewModel: FormViewModel {
    // MARK: - Navigation callbacks
    var gotoSignIn: (() -> Void)?
    var gotoSignOut: ((@escaping (Bool) -> Void) -> Void)?
    var gotoProfile: (() -> Void)?
    var gotoTradeAssociations: (() -> Void)?
    var gotoMyOrders: (() -> Void)?
    var gotoShareApp: (() -> Void)?
    var gotoSettings: (() -> Void)?
    var gotoHelpFeedback: (() -> Void)?
    var showAuthSheet: (() -> Void)?
    
    var goToLanguageSelection: ((@escaping (Language) -> Void) -> Void)?
    
    // MARK: - Internal state
    private var state: State
    
    let authenticationService = NetworkEnvironment.shared.authenticationService
    
    // MARK: - Initialization
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - Public API
    func setLoggedIn(_ isLoggedIn: Bool) {
        state.isLoggedIn = isLoggedIn
        self.sections = makeSections()
        
        Task { @MainActor in
            self.updateLogoutSection()
        }
    }
    
    // MARK: - Sections Creation
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        // Only show header section if logged in
        if state.isLoggedIn {
            sections.append(makeHeaderSection())
        }
        
        // Account & Settings section only visible if logged in
        if state.isLoggedIn {
            sections.append(makeAccountSection())
        }
        
        // More Options section visible to everyone
        sections.append(makeMoreOptionsSection())
        
        // Logout/Login section always visible
        sections.append(makeLogoutSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        let row = makeImageTitleDescriptionRow(
            tag: 1000,
            image: UIImage(systemName: "person.circle.fill"),
            title: "Profile",
            description: "Manage your account details",
            onTap: { [weak self] in self?.gotoProfile?() }
        )
        return FormSection(id: Tags.Section.header.rawValue, cells: [
            makeUserCardRow(),
            row
        ]
        )
    }
    
    @MainActor
    private func updateLogoutSection() {
        guard let index = sections.firstIndex(where: { $0.id == Tags.Section.logout.rawValue }) else { return }
        
        sections[index].cells = [makeLoginButtonRow()]
        reloadSection(index)
    }
    
    private func makeUserCardRow() -> FormRow {
        let profile = state.userProfile
        
        return ImageIdentityHeaderRow(
            tag: -00010,
            config: ImageIdentityHeaderConfig(
                image: .user,
                title: profile?.name ?? "user.profile.default_name".localized,
                subtitle: profile?.email ?? "user.profile.default_email".localized,
                leadingChip: PaddedChipView(
                    text: profile?.verified ?? false
                        ? "user.profile.verified".localized
                        : "user.profile.not_verified".localized,
                    icon: UIImage(systemName: "checkmark.seal.fill"),
                    tint: .systemGreen
                ),
                trailingChip: PaddedChipView(
                    text: "user.profile.since".localized,
                    tint: .secondaryLabel
                ),
                onTap: {
                }
            )
        )
    }
    
    private func makeAccountSection() -> FormSection {
        let rows: [FormRow] = [
            makeImageTitleDescriptionRow(
                tag: 2000,
                image: UIImage(systemName: "bell.fill"),
                title: "account.notifications.title".localized,
                description: "account.notifications.description".localized,
                onTap: { [weak self] in self?.gotoSettings?() }
            ),
            makeImageTitleDescriptionRow(
                tag: 2001,
                image: UIImage(systemName: "person.2.fill"),
                title: "account.trade_associations.title".localized,
                description: "account.trade_associations.description".localized,
                onTap: { [weak self] in self?.gotoTradeAssociations?() }
            ),
            makeImageTitleDescriptionRow(
                tag: 2002,
                image: UIImage(systemName: "bag.fill"),
                title: "account.orders.title".localized,
                description: "account.orders.description".localized,
                onTap: { [weak self] in self?.gotoMyOrders?() }
            )
        ]
        
        return FormSection(id: Tags.Section.account.rawValue, cells: rows)
    }
    
    private func makeMoreOptionsSection() -> FormSection {
        let rows: [FormRow] = [
            makeImageTitleDescriptionRow(
                tag: 3000,
                image: UIImage(systemName: "globe"),
                title: "settings.language.title".localized,
                description: "settings.language.description".localized,
                onTap: { [weak self] in
                    self?.goToLanguageSelection?() { _ in }
                }
            ),
            makeImageTitleDescriptionRow(
                tag: 3001,
                image: UIImage(systemName: "questionmark.circle.fill"),
                title: "common.more_view.help_support".localized,
                description: "common.help_support.description".localized,
                onTap: { [weak self] in self?.gotoHelpFeedback?() }
            ),
            makeImageTitleDescriptionRow(
                tag: 3002,
                image: UIImage(systemName: "square.and.arrow.up"),
                title: "share.app.title".localized,
                description: "share.app.description".localized,
                onTap: { [weak self] in self?.gotoShareApp?() }
            )
        ]
        
        return FormSection(id: Tags.Section.more.rawValue, cells: rows)
    }
    
    private func makeLogoutSection() -> FormSection {
        return FormSection(
            id: Tags.Section.logout.rawValue,
            cells: [makeLoginButtonRow()]
        )
    }
    
    private func makeLoginButtonRow() -> FormRow {
        let title = state.isLoggedIn
            ? "account.logout".localized
            : "account.login_signup".localized

        let style: ButtonStyleType = state.isLoggedIn ? .primary : .outlined

        let buttonModel = ButtonFormModel(
            title: title,
            style: style,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            guard let self = self else { return }

            if self.state.isLoggedIn {
                self.signOut()
            } else {
                if let showSheet = self.showAuthSheet {
                    showSheet()
                } else {
                    self.gotoSignIn?()
                }
            }
        }

        return ButtonFormRow(tag: Tags.Cells.submit.rawValue, model: buttonModel)
    }
    
    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage?,
        title: String,
        description: String,
        onTap: (() -> Void)? = nil
    ) -> FormRow {
        return ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: image,
                imageStyle: .rounded,
                title: title,
                description: description,
                accessoryType: .image(image: UIImage(named: "forwardArrowRightAligned") ?? .forwardArrow),
                onTap: onTap,
                isCardStyleEnabled: true
            )
        )
    }
    
    // MARK: - Sign Out Logic
    func signOut() {
        Task { @MainActor in
            do {
                // 1️⃣ Call logout API
                let _ = try await authenticationService.userLogout(accessToken: state.oauthToken)
                OAuthService().logout()
                
                // 2️⃣ Clear stored user data
                AppStorage.hasLoggedIn = false
                AppStorage.userDetail = nil
                AppStorage.oauthToken = nil
                
                // 3️⃣ Update UI
                self.setLoggedIn(false)
                
                print("✅ User logged out successfully")
            } catch {
                // Handle errors from logout API
                print("❌ Logout failed:", error)
                
                // Optionally, show an alert to the user
                showError("Failure logging out")
            }
        }
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
            case header = 0
            case account = 1
            case more = 2
            case logout = 3
        }
        
        enum Cells: Int {
            case headerTitle = 0
            case submit = 1
        }
    }
}
