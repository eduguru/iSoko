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
    private let associationsService = NetworkEnvironment.shared.associationsService

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

                // Step 1 (our API): association ids (see associationNewsMode). Step 2 (Directus): news for them.
                async let associationNewsTask = fetchAssociationNewsFeed()

                let publicNews = try await publicNewsTask
                let associationNews = await associationNewsTask

                state.newsItems = publicNews
                state.associationNewsItems = associationNews
                state.hasLoaded = true

                await MainActor.run { [weak self] in
                    self?.hideLoader()
                    self?.reloadBodySection(animated: true)
                }

            } catch {

                await MainActor.run { [weak self] in
                    self?.state.hasLoaded = true
                    self?.hideLoader()
                    self?.reloadBodySection(animated: true)
                }

                print("❌ Directus flow failed:", error)
            }
        }
    }

    // MARK: - Association News (2-step)

    /// Which associations feed the "Association News" tab. Flip this one flag to change it.
    enum AssociationNewsMode {
        case off        // don't load association news at all
        case mine       // only associations the signed-in user belongs to (approved memberships)
        case all        // every approved, active association (works for guests too)
    }
    static var associationNewsMode: AssociationNewsMode = .all

    /// 1) our API -> association ids   2) Directus association_news filtered by those ids.
    /// Never throws: a failure here must not hide the public news, so it returns [].
    private func fetchAssociationNewsFeed() async -> [AssociationNewsItem] {
        do {
            let ids: [Int]

            switch Self.associationNewsMode {
            case .off:
                return []

            case .mine:
                guard AppStorage.hasLoggedIn == true,
                      let userId = AppStorage.userProfile?.id else { return [] }
                let mine = try await associationsService.getApprovedAssociations(
                    id: userId,
                    page: 1,
                    count: 100,
                    accessToken: state.oauthToken
                )
                ids = mine.compactMap { $0.id }

            case .all:
                // GET /associations?registrationStatus=Approved&status=Active
                let everyone = try await associationsService.getAllAssociations(
                    page: 1,
                    count: 100,
                    accessToken: state.oauthToken
                )
                ids = everyone.compactMap { $0.id }
            }

            guard !ids.isEmpty else { return [] }
            return try await directusService.fetchAssociationNews(associationIds: ids)
        } catch {
            print("❌ Association news failed:", error)
            return []
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
            sections[index].cells = withEmptyState(makeNewsCells())

        case 1:
            sections[index].cells = withEmptyState(makeAssociationNewsCells())

        default:
            sections[index].cells = []
        }

        sections[index].cells.append(
            SpacerFormRow(tag: 999999, height: 40)
        )

        reloadSection(index)
    }

    /// Shows the empty-state row when a loaded list has no items.
    private func withEmptyState(_ cells: [FormRow]) -> [FormRow] {
        guard state.hasLoaded, cells.isEmpty else { return cells }
        return [EmptyStateFormRow(tag: 999998, config: .noData)]
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
            } ?? "common.label.no_date".localized

            let imageURL = item.featuredImage?.urlString(
                baseURL: ApiEnvironment.directusBaseURL.absoluteString
            )

            return InfoListingFormRow(
                tag: 9000 + index,
                model: InfoListingModel(
                    title: item.title ?? "common.label.no_title".localized,
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
            } ?? "common.label.no_date".localized

            return InfoListingFormRow(
                tag: 10000 + index,
                model: InfoListingModel(
                    title: item.newsTitle ?? "common.label.no_title".localized,
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
        var hasLoaded: Bool = false   // avoids flashing the empty state before the first fetch finishes

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
