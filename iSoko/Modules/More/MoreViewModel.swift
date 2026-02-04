//
//  MoreViewModel.swift
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class MoreViewModel: FormViewModel {
    var gotoSignIn: (() -> Void)? = { }
    var gotoSignOut: (() -> Void)? = { }
    var gotoProfile: (() -> Void)? = { }
    var gotoOrganisations: (() -> Void)? = { }
    var gotoTradeAssociations: (() -> Void)? = { }
    var gotoMyOrders: (() -> Void)? = { }
    var gotoShareApp: (() -> Void)? = { }
    var gotoLegal: (() -> Void)? = { }
    var gotoSettings: (() -> Void)? = { }
    var gotoHelpFeedback: (() -> Void)? = { }

    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Public API

    /// Use this to update login state and refresh UI
    func setLoggedIn(_ isLoggedIn: Bool) {
        state.isLoggedIn = isLoggedIn
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []

        if !state.isLoggedIn {
            sections.append(
                FormSection(
                    id: Tags.Section.header.rawValue,
                    cells: [
                        headerTitleRow,
                        loginButtonRow
                    ]
                )
            )
        }

        sections.append(
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: makeImageRows()
            )
        )

        return sections
    }

    // MARK: - Lazy or Computed Rows

    private lazy var headerTitleRow: FormRow = {
        return TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            title: "",
            description: "Sign in to connect with sellers, explore the iSOKO community, and get personalized recommendations.",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    }()

    private lazy var loginButtonRow: FormRow = {
        let buttonModel = ButtonFormModel(
            title: "Log in or sign up",
            style: .primary,
            size: .medium,
            icon: UIImage(systemName: "email.fill"),
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoSignIn?()
        }

        return ButtonFormRow(tag: 1001, model: buttonModel)
    }()

    /// Generates a reusable ImageTitleDescriptionRow
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

    /// Easily loop and create multiple rows
    
    private func makeRowItemsArray() -> [RowItemModel] {
        var items: [RowItemModel] = []

        // Common rows for both logged-in and logged-out users
        items.append(contentsOf: [
            RowItemModel(title: "Legal", description: "See terms, policies, and privacy", image: .legalIcon, onTap: { [weak self] in
                self?.gotoLegal?()
            }),
            RowItemModel(title: "Security and settings", description: "Update your personal details", image: .settingsGearIcon, onTap: { [weak self] in
                self?.gotoLegal?()
            }),
            RowItemModel(title: "Help and feedback", description: "Get customer support", image: .questionCircleIcon, onTap: { [weak self] in
                self?.gotoHelpFeedback?()
            })
        ])

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

    // MARK: - State

    private struct State {
        var isLoggedIn: Bool = true
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }

        enum Cells: Int {
            case headerImage = 0
            case headerTitle = 1
        }
    }
}
