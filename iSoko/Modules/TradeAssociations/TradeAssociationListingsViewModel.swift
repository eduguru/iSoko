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

    // MARK: - Make sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(id: Tags.Section.header.rawValue, cells: [segmentedOptions]),
            FormSection(id: Tags.Section.body.rawValue, cells: makeImageRows(for: state.selectedSegmentIndex))
        ]
    }

    // MARK: - Lazy Segment Row
    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private func makeOptionsSegmentFormRow() -> FormRow {
        let styledSegmentRow = SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Your Associations", "Requested", "Discover"],
                selectedIndex: state.selectedSegmentIndex,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] selectedIndex in
                    guard let self = self else { return }
                    self.state.selectedSegmentIndex = selectedIndex
                    self.reloadBodySection()
                }
            )
        )
        return styledSegmentRow
    }

    // MARK: - Body Reload Logic
    private func reloadBodySection() {
        // Replace the "body" section with updated rows
        var updatedSections = sections

        let newBodyRows = makeImageRows(for: state.selectedSegmentIndex)
        let newBodySection = FormSection(id: Tags.Section.body.rawValue, cells: newBodyRows)

        if updatedSections.count > 1 {
            updatedSections[1] = newBodySection
        } else {
            updatedSections.append(newBodySection)
        }

        // Trigger UI reload automatically through didSet
        self.sections = updatedSections

        // Optionally, if you want a fade animation on the body section:
        onReloadSection?(Tags.Section.body.rawValue)
    }

    // MARK: - Generate Rows
    private func makeImageTitleDescriptionRow(from item: RowItemModel, tag: Int) -> FormRow {
        ImageTitleDescriptionBottomRow(
            tag: tag,
            config: .init(
                image: item.image,
                title: item.title,
                description: item.description,
                bottomLabelText: item.bottomLabelText,
                bottomButtonTitle: item.bottomButtonTitle,
                bottomButtonStyle: item.bottomButtonStyle ?? .plain,
                onBottomButtonTap: item.onBottomButtonTap,
                accessoryType: .chevron,
                onTap: item.onTap,
                isCardStyleEnabled: true
            )
        )
    }

    // MARK: - Segment-based Row Items
    private func makeRowItemsArray(for segmentIndex: Int) -> [RowItemModel] {
        var items: [RowItemModel] = []

        switch segmentIndex {
        case 0: // Your Associations — bottom label
            for i in 1...5 {
                items.append(
                    RowItemModel(
                        title: "Association \(i)",
                        description: "You are a verified member.",
                        image: .settingsGearIcon,
                        bottomLabelText: "Member since 20\(15 + i)",
                        onTap: { [weak self] in self?.goToMoreDetails?() }
                    )
                )
            }

        case 1: // Requested — secondary cancel button
            for i in 1...5 {
                items.append(
                    RowItemModel(
                        title: "Pending Request \(i)",
                        description: "Awaiting approval.",
                        image: .legalIcon,
                        bottomButtonTitle: "Cancel",
                        bottomButtonStyle: .secondary,
                        onBottomButtonTap: { print("Cancel request \(i) tapped") },
                        onTap: { [weak self] in self?.goToMoreDetails?() }
                    )
                )
            }

        case 2: // Discover — primary join button
            for i in 1...5 {
                items.append(
                    RowItemModel(
                        title: "Discover Association \(i)",
                        description: "Explore new trade opportunities.",
                        image: .questionCircleIcon,
                        bottomButtonTitle: "Join",
                        bottomButtonStyle: .primary,
                        onBottomButtonTap: { print("Join association \(i) tapped") },
                        onTap: { [weak self] in self?.goToMoreDetails?() }
                    )
                )
            }

        default:
            break
        }

        return items
    }

    // MARK: - Convert to Rows
    private func makeImageRows(for segmentIndex: Int) -> [FormRow] {
        let items = makeRowItemsArray(for: segmentIndex)
        return items.enumerated().map { index, item in
            makeImageTitleDescriptionRow(from: item, tag: 2000 + index)
        }
    }

    // MARK: - State
    private struct State {
        var isLoggedIn: Bool = true
        var selectedSegmentIndex: Int = 0
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
    }
}
