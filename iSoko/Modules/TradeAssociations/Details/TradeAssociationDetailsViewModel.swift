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
    var goToNewsDetails: (() -> Void)? = { }
    
    private var state: State

    init(_ data: AssociationResponse) {
        state = State(data: data)
        
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
                title: state.data.name ?? "",
                subtitle: "Founded in " + (state.data.foundedIn ?? "00"),
                desc: "\(state.data.members ?? 0)" + " Members",
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
                title: state.data.emailAddress ?? "email",
                description: ""
            ),
            makeImageTitleDescriptionRow(
                tag: 2002,
                image: .activate,
                title: state.data.phoneNumber ?? "phoneNumber",
                description: ""
            ),
            makeImageTitleDescriptionRow(
                tag: 2003,
                image: .location,
                title: state.data.physicalAddress ?? "physicalAddress",
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
        var data: AssociationResponse
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
    }
}
