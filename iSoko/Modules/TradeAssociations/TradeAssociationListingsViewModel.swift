//
//  TradeAssociationListingsViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class TradeAssociationListingsViewModel: FormViewModel {
    var goToMoreDetails: (() -> Void)? = { }

    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []

        sections.append(FormSection( id: Tags.Section.header.rawValue, cells: [segmentedOptions]))
        sections.append(FormSection( id: Tags.Section.body.rawValue, cells: makeImageRows()))

        return sections
    }

    // MARK: - Lazy or Computed Rows
    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private func makeOptionsSegmentFormRow() -> FormRow {
        let styledSegmentRow = SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Your Associations", "Requested", "Discover"],
                selectedIndex: 0,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { selectedIndex in
                    print("Segment changed to index: \(selectedIndex)")
                }
            )
        )

        return styledSegmentRow
    }

    // MARK: - Generate Row
    private func makeImageTitleDescriptionRow(from item: RowItemModel, tag: Int) -> FormRow {
        
        let row = ImageTitleDescriptionBottomRow(
            tag: 5001,
            config: .init(
                image: item.image,
                title: item.title,
                description: item.description,
                bottomLabelText: item.bottomLabelText,
                bottomButtonTitle: item.bottomButtonTitle,
                bottomButtonStyle: item.bottomButtonStyle ?? .plain,
                onBottomButtonTap: {
                    print("Contact button tapped")
                },
                accessoryType: .chevron,
                onTap: {
                    print("Cell tapped")
                },
                isCardStyleEnabled: true
            )
        )
        
        return row
    }

    // MARK: - Row Item Array
    private func makeRowItemsArray() -> [RowItemModel] {
        [
            RowItemModel(
                title: "Legal",
                description: "See terms, policies, and privacy",
                image: .legalIcon,
                onTap: { [weak self] in self?.goToMoreDetails?() }
            ),
            RowItemModel(
                title: "Security and Settings",
                description: "Update your personal details",
                image: .settingsGearIcon,
                bottomLabelText: "Recommended: Enable 2FA",
                onTap: { [weak self] in self?.goToMoreDetails?() }
            ),
            RowItemModel(
                title: "Help and Feedback",
                description: "Get customer support",
                image: .questionCircleIcon,
                bottomButtonTitle: "Contact Support",
                bottomButtonStyle: .secondary,
                onTap: { [weak self] in self?.goToMoreDetails?() }
            ),
            RowItemModel(
                title: "Membership Renewal",
                description: "Your membership expires soon.",
                image: .addNote,
                bottomLabelText: "Expires in 7 days",
                bottomButtonTitle: "Renew Now",
                bottomButtonStyle: .primary,
                onTap: { [weak self] in self?.goToMoreDetails?() }
            )
        ]
    }

    // MARK: - Convert to Rows
    private func makeImageRows() -> [FormRow] {
        let items = makeRowItemsArray()

        return items.enumerated().map { index, item in
            makeImageTitleDescriptionRow(from: item, tag: 2000 + index)
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
