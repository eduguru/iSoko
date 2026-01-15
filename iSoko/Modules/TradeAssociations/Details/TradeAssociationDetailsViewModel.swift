//
//  TradeAssociationDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class TradeAssociationDetailsViewModel: FormViewModel {

    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
        reloadBodySection() // show initial segment
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []

        sections.append(makeHeaderSection())
        sections.append(makeAboutSection())
        sections.append(makeNewsSection())

        return sections
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            cells: [
                associationsHeader,
                segmentedOptions
            ]
        )
    }

    private func makeAboutSection() -> FormSection {
        FormSection(
            id: Tags.Section.about.rawValue,
            cells: []
        )
    }

    private func makeNewsSection() -> FormSection {
        FormSection(
            id: Tags.Section.info.rawValue,
            cells: []
        )
    }

    // MARK: - Section Updates

    private func updateAboutSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.about.rawValue
        }) else { return }

        sections[index].cells = makeAboutCells()
        reloadSection(index)
    }

    private func updateNewsSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.info.rawValue
        }) else { return }

        sections[index].cells = makeInfoCells()
        reloadSection(index)
    }

    private func clearAboutSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.about.rawValue
        }) else { return }

        sections[index].cells = []
        reloadSection(index)
    }

    private func clearNewsSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.info.rawValue
        }) else { return }

        sections[index].cells = []
        reloadSection(index)
    }

    // MARK: - Segment Switching Logic

    private func reloadBodySection() {
        switch state.selectedSegmentIndex {
        case 0: // About
            clearNewsSection()
            updateAboutSection()

        case 1: // News
            clearAboutSection()
            updateNewsSection()

        default:
            break
        }
    }

    // MARK: - Lazy Rows

    private lazy var segmentedOptions = makeOptionsSegmentFormRow()
    private lazy var associationsHeader: FormRow = makeAssociationsHeaderFormRow()
    private lazy var pillsFilter: FormRow = makePillsFilterFormRow()
    private lazy var infoListing: FormRow = makeInfoListingFormRow()

    // MARK: - Rows

    private func makeOptionsSegmentFormRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["About", "News"],
                selectedIndex: state.selectedSegmentIndex,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self else { return }
                    self.state.selectedSegmentIndex = index
                    self.reloadBodySection()
                }
            )
        )
    }

    private func makeAssociationsHeaderFormRow() -> FormRow {
        let model = AssociationHeaderModel(
            title: "Baraka Womens Football Club",
            subtitle: "Founded in 2025",
            desc: "12 Members",
            icon: .activate,
            cardBackgroundColor: .white,
            cardRadius: 0
        )

        return AssociationHeaderFormRow(
            tag: 001001,
            model: model
        )
    }

    private func makePillsFilterFormRow() -> FormRow {
        PillsFormRow(
            tag: 0090,
            items: [
                PillItem(id: "01", title: "Hey there"),
                PillItem(id: "03", title: "Hey you"),
                PillItem(id: "04", title: "Hey man"),
                PillItem(id: "05", title: "Hey girl"),
                PillItem(id: "06", title: "Hey there"),
                PillItem(id: "07", title: "Hey")
            ]
        )
    }

    private func makeInfoListingFormRow() -> FormRow {
        InfoListingFormRow(
            tag: 0101001,
            model: InfoListingModel(
                title: "Baraka Womens Football Club",
                subtitle: "Founded in 2025",
                desc: "12 Members",
                icon: .activate,
                cardBackgroundColor: .white,
                cardRadius: 0
            )
        )
    }

    // MARK: - About Rows

    private func makeAboutCells() -> [FormRow] {
        makeAboutRowItemsArray().enumerated().map { index, item in
            makeImageTitleDescriptionRow(
                tag: 2000 + index,
                image: item.image,
                title: item.title,
                description: item.description,
                onTap: item.onTap
            )
        }
    }

    private func makeAboutRowItemsArray() -> [RowItemModel] {
        [
            RowItemModel(
                title: "www.assocation-website.com",
                description: "",
                image: .link,
                onTap: {}
            ),
            RowItemModel(
                title: "+254 738 789 333",
                description: "",
                image: .activate,
                onTap: {}
            ),
            RowItemModel(
                title: "Nairobi, Kenya",
                description: "",
                image: .location,
                onTap: {}
            )
        ]
    }

    // MARK: - News Rows

    private func makeInfoCells() -> [FormRow] {
        var rows: [FormRow] = []

        for i in 0..<9 {
            rows.append(
                InfoListingFormRow(
                    tag: 9000 + i,
                    model: InfoListingModel(
                        title: "Finance \(i)",
                        subtitle: "Updated Test cases for BulkPaymentRecipientViewModel",
                        desc: "10:00 AM",
                        icon: .addPhoto,
                        cardBackgroundColor: .white,
                        cardRadius: 0
                    )
                )
            )
        }

        return rows
    }

    // MARK: - Shared Row Factory

    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage,
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
                accessoryType: .none,
                onTap: onTap,
                isCardStyleEnabled: true
            )
        )
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
            case about = 1
            case info = 2
        }

        enum Cells: Int {
            case headerImage = 0
            case headerTitle = 1
        }
    }
}
