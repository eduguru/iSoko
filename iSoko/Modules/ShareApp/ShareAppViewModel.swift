//
//  ShareAppViewModel.swift
//
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class ShareAppViewModel: FormViewModel {
    
    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = [
            FormSection(id: Tags.Section.header.rawValue, cells: [imageFormRow])
        ]
        
        sections.append(
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: makeImageRows()
            )
        )

        return sections
    }

    // MARK: - Lazy or Computed Rows
    
    lazy var imageFormRow = ImageFormRow(
        tag: 2,
        config: .init(
            image: .referBanner,
            height: 220,
            fillWidth: true,
            backgroundColor: .bannerYellow
        )
    )
    
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
                accessoryType: .none,
                onTap: onTap,
                isCardStyleEnabled: false
            )
        )
    }

    /// Easily loop and create multiple rows
    
    private func makeRowItemsArray() -> [RowItemModel] {
        var items: [RowItemModel] = []
        
        let avatar01 = UIImage.fromInitials(
            "JD",
            size: CGSize(width: 80, height: 80),
            textColor: .white,
            backgroundColor: .app(.primary),
            borderColor: .black,
            borderWidth: 2,
            shape: .circle,
            addShadow: true
        )

        // Common rows for both logged-in and logged-out users
        items.append(contentsOf: [
            RowItemModel(
                title: "Share Your Code",
                description: "Share Your Code Send your unique promo code to friends and family",
                image: avatar01,
                onTap: { }
            ),
            RowItemModel(
                title: "They Sign Up",
                description: "When they register and verify their account using your code",
                image: avatar01,
                onTap: { }
            ),
            RowItemModel(
                title: "Earn Rewards",
                description: "You both receive points that can be redeemed for rewards",
                image: avatar01,
                onTap: { }
            ),
        ])

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
