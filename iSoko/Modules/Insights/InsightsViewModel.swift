//
//  InsightsViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import UIKit
import DesignSystemKit
import UtilsKit
import StorageKit

// MARK: - Stock Report VM
final class InsightsViewModel: FormViewModel {

    var gotoConfirm: ((ReportSelectionPayload) -> Void)?
    var goToDetails: (() -> Void)? = { }
    var goToEvents: (() -> Void)? = { }

    var goToNewsDetails: ((DirectusNewsItem) -> Void)? = { _ in }
    var goToAssociationNewsDetails: ((AssociationNewsItem) -> Void)? = { _ in }

    // MARK: - Callbacks
    var handleMarketPrices: (() -> Void)?
    var handleTradeDocuments: (() -> Void)?
    var handleTradeProcedures: (() -> Void)?
    var handleRegulatoryAgencies: (() -> Void)?
    var handleStandards: (() -> Void)?
    var handleTaxInformation: (() -> Void)?
    var handleEvents: (() -> Void)?
    var handleForum: (() -> Void)?

    private var state = State()
    private let directusService = DirectusTokenService()

    override init() {
        super.init()
        sections = makeSections()
        reloadBodySection(animated: false)
    }

    // MARK: - Lifecycle

    override func refresh() {
        fetchData()
    }

    override func fetchData() {

        showLoader()

        Task {
            do {

                try await directusService.login(
                    email: AppStorage.email,
                    password: AppStorage.password
                )

                async let publicNewsTask = directusService.fetchNews()

                // HARD CODED ASSOCIATION ID FOR NOW
                async let associationNewsTask = directusService.fetchAssociationNews(
                    associationId: "1"
                )

                let publicNews = try await publicNewsTask
                let associationNews = try await associationNewsTask

                state.newsItems = publicNews
                state.associationNewsItems = associationNews

                await MainActor.run { [weak self] in
                    self?.hideLoader()
                    self?.reloadBodySection(animated: true)
                }

            } catch {

                await MainActor.run { [weak self] in
                    self?.hideLoader()
                }

                print("❌ Directus flow failed:", error)
            }
        }
    }

    // MARK: - Section Builder

    private func makeSections() -> [FormSection] {
        [
            makeAnalyticsSection(),
            makeHeaderSection(),
            makeBodySection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: SectionTag.header.rawValue,
            title: "news.latest_business_news.title".localized,
            cells: [
                segmentedOptions
            ]
        )
    }

    private func makeAnalyticsSection() -> FormSection {
        FormSection(
            id: SectionTag.analytics.rawValue,
            cells: makeImageRows()
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: SectionTag.body.rawValue,
            actionTitle: nil,
            onActionTapped: {},
            cells: []
        )
    }

    // MARK: - Reload Body Section

    private func reloadBodySection(animated: Bool = true) {

        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.body.rawValue
        }) else { return }

        switch state.selectedSegmentIndex {

        case 0:
            sections[index].cells = makeNewsCells()

        case 1:
            sections[index].cells = makeAssociationNewsCells()

        default:
            sections[index].cells = []
        }

        sections[index].cells.append(
            SpacerFormRow(tag: 999999, height: 40)
        )

        reloadSection(index)
    }

    // MARK: - Segments

    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private func makeOptionsSegmentFormRow() -> FormRow {

        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: [
                    "news.segment.public_news".localized,
                    "news.segment.association_news".localized
                ],
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

    // MARK: - Analytics Section

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
        var items: [RowItemModel] = []

        items.append(contentsOf: [
            RowItemModel(
                title: "events.title".localized,
                description: "events.description".localized,
                image: UIImage(systemName: "calendar.badge"),
                onTap: { [weak self] in
                    self?.goToEvents?()
                }
            )
        ])

        return items
    }

    // MARK: - Shared Rows

    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage?,
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
                accessoryType: .image(
                    image: UIImage(named: "forwardArrowRightAligned")
                    ?? .forwardArrow
                ),
                onTap: onTap,
                isCardStyleEnabled: true
            )
        )
    }

    // MARK: - Public News

    private func makeNewsCells() -> [FormRow] {

        state.newsItems.enumerated().map { index, item in

            let createdDate: Date? = {
                guard let createdOn = item.createdOn else { return nil }
                return parseDirectusDate(createdOn)
            }()

            let createdOnText = createdDate.map {
                formatNewsDate($0)
            } ?? "No Date"

            let imageURL = item.featuredImage?
                .urlString(baseURL: "https://directus.dev.isoko.africa/")

            return InfoListingFormRow(
                tag: 9000 + index,
                model: InfoListingModel(
                    title: item.title ?? "No Title",
                    subtitle: item.newsCategory?.collection ?? "",
                    desc: createdOnText,
                    icon: .blankRectangle,
                    imageURL: imageURL,
                    cardBackgroundColor: .white,
                    cardRadius: 0,
                    onTap: { [weak self] in
                        self?.handleNewsTap(index: index)
                    }
                )
            )
        }
    }

    // MARK: - Association News

    private func makeAssociationNewsCells() -> [FormRow] {

        state.associationNewsItems.enumerated().map { index, item in

            let createdDate: Date? = {
                guard let createdOn = item.createdOn else { return nil }
                return parseDirectusDate(createdOn)
            }()

            let createdOnText = createdDate.map {
                formatNewsDate($0)
            } ?? "No Date"

            return InfoListingFormRow(
                tag: 10000 + index,
                model: InfoListingModel(
                    title: item.newsTitle ?? "No Title",
                    subtitle: item.newsCategory ?? "",
                    desc: createdOnText,
                    icon: .blankRectangle,
                    cardBackgroundColor: .white,
                    cardRadius: 0,
                    onTap: { [weak self] in
                        self?.handleAssociationNewsTap(index: index)
                    }
                )
            )
        }
    }

    // MARK: - News Actions

    private func handleNewsTap(index: Int) {

        guard state.newsItems.indices.contains(index) else { return }

        let item = state.newsItems[index]
        goToNewsDetails?(item)
    }

    private func handleAssociationNewsTap(index: Int) {

        guard state.associationNewsItems.indices.contains(index) else { return }

        let item = state.associationNewsItems[index]
        goToAssociationNewsDetails?(item)
    }

    // MARK: - Date Helpers

    private func parseDirectusDate(_ isoString: String) -> Date? {

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

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

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var selectedSegmentIndex: Int = 0

        var selectedReport: ReportType?

        var newsItems: [DirectusNewsItem] = []
        var associationNewsItems: [AssociationNewsItem] = []

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    // MARK: - Enums

    private enum SectionTag: Int {
        case title = 0
        case action
        case recentActivities = 4
        case filter
        case selection
        case financialSummary
        case body
        case analytics
        case header
    }

    private enum CellTag: Int {
        case reportTitle = 0
        case continueButton = 1
        case recentActivities = 4
        case category
    }
}
