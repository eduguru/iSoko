//
//  NewsListingViewModel.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class NewsListingViewModel: FormViewModel {
    var goToNewsDetails: (() -> Void)? = { }
    
    private var state = State()

    override init() {
        super.init()
        self.sections = makeSections()
        reloadBodySection(animated: false)
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection()
        ]
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

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: []
        )
    }

    // MARK: - Body Switching (Single Section)

    private func reloadBodySection(animated: Bool = true) {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.body.rawValue
        }) else { return }

        let newCells: [FormRow]

        switch state.selectedSegmentIndex {
        case 0:
            newCells = makeAboutCells()
        case 1:
            newCells = makeInfoCells()
        default:
            newCells = []
        }

        sections[index].cells = newCells

        animated
        ? reloadSection(index)
        : reloadSection(index)
    }

    // MARK: - Lazy Rows

    private lazy var segmentedOptions = makeOptionsSegmentFormRow()
    private lazy var associationsHeader = makeAssociationsHeaderFormRow()
    private lazy var searchRow = makeSearchRow()
    
    private func makeSearchRow() -> FormRow {
        SearchFormRow(
            tag: Tags.Cells.searchBar.rawValue,
            model: SearchFormModel(
                placeholder: "Search",
                keyboardType: .default,
                searchIcon: UIImage(systemName: "magnifyingglass"),
                searchIconPlacement: .right,
                filterIcon: nil,
                didTapSearchIcon: { print("🔍 Search tapped") },
                didTapFilterIcon: { print("⚙️ Filter tapped") }
            )
        )
    }

    // MARK: - Segmented Control

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
                    self.reloadBodySection(animated: true)
                }
            )
        )
    }

    // MARK: - Header

    private func makeAssociationsHeaderFormRow() -> FormRow {
        AssociationHeaderFormRow(
            tag: 001001,
            model: AssociationHeaderModel(
                title: "Baraka Womens Football Club",
                subtitle: "Founded in 2025",
                desc: "12 Members",
                icon: .activate,
                cardBackgroundColor: .white,
                cardRadius: 0
            )
        )
    }

    // MARK: - About

    private func makeAboutCells() -> [FormRow] {
        [
            makeImageTitleDescriptionRow(
                tag: 2001,
                image: .link,
                title: "www.association-website.com",
                description: ""
            ),
            makeImageTitleDescriptionRow(
                tag: 2002,
                image: .activate,
                title: "+254 738 789 333",
                description: ""
            ),
            makeImageTitleDescriptionRow(
                tag: 2003,
                image: .location,
                title: "Nairobi, Kenya",
                description: ""
            )
        ]
    }

    // MARK: - News

    private func makeInfoCells() -> [FormRow] {
        (0..<9).map { i in
            InfoListingFormRow(
                tag: 9000 + i,
                model: InfoListingModel(
                    title: "Finance \(i)",
                    subtitle: "Updated Test cases",
                    desc: "10:00 AM",
                    icon: .addPhoto,
                    cardBackgroundColor: .white,
                    cardRadius: 0,
                    onTap: { [weak self] in
                        self?.handleInfoTap(index: i)
                    }
                )
            )
        }
    }

    private func handleInfoTap(index: Int) {
        print("Tapped item at index: \(index)")
        goToNewsDetails?()
        // navigation / analytics / routing here
    }

    // MARK: - Shared Row Builder
    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage,
        title: String,
        description: String
    ) -> FormRow {
        ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: image,
                imageStyle: .rounded,
                title: title,
                description: description,
                accessoryType: .none,
                onTap: nil,
                isCardStyleEnabled: true
            )
        )
    }

    // MARK: - State

    private struct State {
        var selectedSegmentIndex: Int = 0
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
        enum Cells: Int {
            case searchBar = 0
            case segmentControl = 1
            case headerTitle = 2
            
        }
    }
}
