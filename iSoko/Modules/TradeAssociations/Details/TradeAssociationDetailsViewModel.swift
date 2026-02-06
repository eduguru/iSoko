//
//  TradeAssociationDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class TradeAssociationDetailsViewModel: FormViewModel {

    var goToNewsDetails: ((AssociationNewsItem) -> Void)? = { _ in }

    private var state: State
    private let directusService = DirectusTokenService()

    init(_ data: AssociationResponse) {
        state = State(data: data)
        super.init()
        self.sections = makeSections()
        reloadBodySection(animated: false)
    }

    override func fetchData() {
        Task {
            do {
                try await directusService.login(
                    email: "admin@isoko.twcc-tz.org",
                    password: "s^k2HIza)KpdER5b"
                )

                let id: Int = state.data.id ?? 0
                let news = try await directusService.fetchAssociationNews(associationId: "\(id)")

                state.newsItems = news
                updateSection(at: Tags.Section.body.rawValue)

            } catch {
                print("❌ Directus flow failed:", error)
            }
        }
    }

    // MARK: - Update Section

    private func updateSection(at index: Int) {
        guard index >= 0 && index < sections.count else { return }

        switch state.selectedSegmentIndex {
        case 0:
            sections[index].cells = makeAboutCells()
        case 1:
            sections[index].cells = makeNewsCells()
        default:
            sections[index].cells = []
        }

        reloadSection(index)
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

        switch state.selectedSegmentIndex {
        case 0:
            sections[index].cells = makeAboutCells()
        case 1:
            sections[index].cells = makeNewsCells()
        default:
            sections[index].cells = []
        }

        reloadSection(index)
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
                icon: .blankRectangle,
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

    private func makeNewsCells() -> [FormRow] {
        state.newsItems.enumerated().map { index, item in
            
            // Parse createdOn ISO string into Date
            let createdDate: Date? = {
                guard let createdOn = item.createdOn else { return nil }
                return parseDirectusDate(createdOn)
            }()
            
            // Format the date for display
            let createdOnText = createdDate.map { formatNewsDate($0) } ?? "No Date"

            return InfoListingFormRow(
                tag: 9000 + index,
                model: InfoListingModel(
                    title: item.newsTitle ?? "No Title",
                    subtitle: item.newsCategory ?? "",
                    desc: createdOnText,
                    icon: .blankRectangle,
                    cardBackgroundColor: .white,
                    cardRadius: 0,
                    onTap: { [weak self] in
                        self?.handleNewsTap(index: index)
                    }
                )
            )
        }
    }

    private func handleNewsTap(index: Int) {
        guard state.newsItems.indices.contains(index) else { return }
        let item = state.newsItems[index]
        goToNewsDetails?(item)
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

    private func parseDirectusDate(_ isoString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: isoString)
    }

    private func formatNewsDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, hh:mm a"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }

    
    // MARK: - State

    private struct State {
        var selectedSegmentIndex: Int = 0
        var data: AssociationResponse
        var newsItems: [AssociationNewsItem] = []
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
    }
}
