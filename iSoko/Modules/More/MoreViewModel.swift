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
    // Callback closures for navigation
    var gotoSignIn: (() -> Void)?
    var gotoSignOut: ((@escaping (Bool) -> Void) -> Void)?
    var gotoProfile: (() -> Void)?
    var gotoOrganisations: (() -> Void)?
    var gotoTradeAssociations: (() -> Void)?
    var gotoMyOrders: (() -> Void)?
    var gotoShareApp: (() -> Void)?
    var gotoLegal: (() -> Void)?
    var gotoSettings: (() -> Void)?
    var gotoHelpFeedback: (() -> Void)?
    var showAuthSheet: (() -> Void)?
    
    // Internal state
    private var state: State
    
    // MARK: - Initialization
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections() // Initial section setup
    }
    
    // MARK: - Public API
    
    /// Use this to update login state and refresh UI
    func setLoggedIn(_ isLoggedIn: Bool) {
        state.isLoggedIn = isLoggedIn
        self.sections = makeSections() // Regenerate sections based on login state
    }
    
    // MARK: - Sections Creation
    
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        if !state.isLoggedIn {
            sections.append(FormSection(id: Tags.Section.header.rawValue, cells: [headerTitleRow]))
        }
        
        sections.append(FormSection(id: Tags.Section.body.rawValue, cells: makeImageRows()))
        sections.append(FormSection(id: Tags.Section.submit.rawValue, cells: [loginButtonRow]))
        
        return sections
    }
    
    // MARK: - Lazy or Computed Rows
    
    private lazy var headerTitleRow: FormRow = {
        return TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            model: TitleDescriptionModel(
                title: "",
                description: "Sign in to connect with sellers, explore the iSOKO community, and get personalized recommendations.",
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .none,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left
            )
        )
    }()
    
    private lazy var loginButtonRow: FormRow = {
        let title = state.isLoggedIn ? "Log out" : "Log in or sign up"
        let style: ButtonStyleType = state.isLoggedIn ? .primary : .outlined
        
        let buttonModel = ButtonFormModel(
            title: title,
            style: style,
            size: .medium,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.state.isLoggedIn ?? false ? self?.signOut() : self?.gotoSignIn?()
        }
        
        return ButtonFormRow(tag: Tags.Cells.submit.rawValue, model: buttonModel)
    }()
    
    // MARK: - Sign Out Logic
    
    func signOut() {
        gotoSignOut? { success in
            if success {
                print("Successfully signed out.")
                // Clear user data on successful sign-out
                AppStorage.hasLoggedIn = false
                AppStorage.userProfile = nil
                AppStorage.oauthToken = nil
                
                // After signing out, update sections to reflect login state
                DispatchQueue.main.async { [weak self] in
                    self?.setLoggedIn(false)  // Re-generate sections after sign-out
                }
            } else {
                print("Sign-out failed or canceled.")
            }
        }
    }
    
    // MARK: - Image Row Creation
    
    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage,
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
    
    private func makeImageRows() -> [FormRow] {
        let items = makeRowItemsArray()
        return items.enumerated().map { index, item in
            makeImageTitleDescriptionRow(
                tag: 2000 + index,
                image: item.image,
                title: item.title,
                description: item.description,
                onTap: item.onTap
            )
        }
    }
    
    private func makeRowItemsArray() -> [RowItemModel] {
        var items: [RowItemModel] = [
            RowItemModel(title: "Legal", description: "See terms, policies, and privacy", image: .legalIcon, onTap: { [weak self] in
                self?.gotoLegal?()
            }),
            RowItemModel(title: "Security and settings", description: "Update your personal details", image: .settingsGearIcon, onTap: { [weak self] in
                self?.gotoSettings?()
            }),
            RowItemModel(title: "Help and feedback", description: "Get customer support", image: .questionCircleIcon, onTap: { [weak self] in
                self?.gotoHelpFeedback?()
            })
        ]
        
        // Add additional rows when logged in
        if state.isLoggedIn {
            items.insert(contentsOf: [
                RowItemModel(title: "Profile Information", description: "Manage your account details", image: .profile, onTap: { [weak self] in
                    self?.gotoProfile?()
                }),
                RowItemModel(title: "Trade Associations", description: "Caption about association", image: .tradeIcon, onTap: { [weak self] in
                    self?.gotoTradeAssociations?()
                }),
                RowItemModel(title: "My Orders", description: "View your wishlist", image: .bagAddIcon, onTap: { [weak self] in
                    self?.gotoMyOrders?()
                }),
                RowItemModel(title: "Share App & Earn", description: "Get customer support", image: .shareAppIcon, onTap: { [weak self] in
                    self?.gotoShareApp?()
                })
            ], at: 0)
        }
        
        return items
    }
    
    // MARK: - State
    
    private struct State {
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userProfile
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
    }
    
    // MARK: - Tags
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
            case submit
        }
        
        enum Cells: Int {
            case headerImage = 0
            case headerTitle = 1
            case submit
        }
    }
}
