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
    var gotoSignUp: (() -> Void)? = { }

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
    
    private func makeRowItemsArray() -> [(String, String, UIImage)] {
        var items: [(String, String, UIImage)] = []

        // Shared rows for all users
        items.append(contentsOf: [
            ("Legal", "See terms, policies, and privacy", .settings),
            ("Security and settings", "Update your personal details", .activate),
            ("Help and feedback", "Get customer support", .accountTabIcon)
        ])

        if state.isLoggedIn {
            items.insert(contentsOf: [
                ("Profile Information", "Manage your account details", .accountTabIcon),
                ("Organisations", "Caption organisation benefits", .accountTabIcon),
                ("Trade Associations", "Caption about association", .accountTabIcon),
                ("My Orders", "View your wishlist", .accountTabIcon),
                ("Share App & Earn", "Get customer support", .accountTabIcon)
            ], at: 0) // Add these before the common ones
        }

        return items
    }

    
    private func makeImageRows() -> [FormRow] {
        let items: [(String, String, UIImage)] = makeRowItemsArray()

        return items.enumerated().map { index, item in
            makeImageTitleDescriptionRow(
                tag: 2000 + index,
                image: item.2,
                title: item.0,
                description: item.1,
                onTap: {
                    print("Tapped on: \(item.0)")
                }
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
