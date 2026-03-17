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

struct ServiceItem {
    let id: String
    let title: String
    let onTap: (() -> Void)?
}

// MARK: - Stock Report VM
final class InsightsViewModel: FormViewModel {
    var gotoConfirm: ((ReportSelectionPayload) -> Void)?
    var goToDetails: (() -> Void)? = { }
    
    var goToNewsDetails: ((DirectusNewsItem) -> Void)? = { _ in }
    
    // MARK: - Callbacks (Now Optional)
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
    }
    
    override func fetchData() {
        Task {
            do {
                try await directusService.login(
                    email: "admin@isoko.twcc-tz.org",
                    password: "s^k2HIza)KpdER5b"
                )

                let news = try await directusService.fetchNews()

                state.newsItems = news
                updateSection(at: SectionTag.body.rawValue)

            } catch {
                print("❌ Directus flow failed:", error)
            }
        }
    }
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            makeTitleSection(),
            makeSelectionSection(),
            makeBodySection()
        ]
    }
    
    private func makeTitleSection() -> FormSection {
        FormSection(
            id: SectionTag.action.rawValue,
            cells: [
                titleDescriptionFormRow
            ]
        )
    }
    
    private func makeSelectionSection() -> FormSection {
        FormSection(
            id: SectionTag.selection.rawValue,
            cells: [
                selectionInputRow,
                SpacerFormRow(tag: 000)
            ]
        )
    }
    
    private func makeBodySection() -> FormSection {
        FormSection(
            id: SectionTag.body.rawValue,
            title: "Latest Business News",
            actionTitle: "See All",
            onActionTapped: {
                
            },
            cells: []
        )
    }
    
    // MARK: - Update Section

    private func updateSection(at index: Int) {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == SectionTag.body.rawValue }) else {
            return
        }

        sections[sectionIndex].cells = makeNewsCells()

        reloadSection(sectionIndex)
    }
    
    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: CellTag.reportTitle.rawValue,
            title: title,
            description:description,
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .subheadline,
            descriptionFontStyle: .body
        )
    }

    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(title: "Business Hub", description: "Resources and guides for your business")
    
    private lazy var selectionInputRow: FormRow = makeSelectionGrid()
    
    private func makeSelectionGrid() -> FormRow {
        
        SelectableCardGridRow(
            tag: CellTag.category.rawValue,
            config: .init(
                items: [
                    .init(
                        title: "Market Prices",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                            self?.handleMarketPrices
                        }),
                    .init(
                        title: "Trade Procedures",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                            self?.handleTradeProcedures
                        }),
                    .init(
                        title: "Events",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                            self?.handleEvents
                        }),
                    .init(
                        title: "Regulatory Agencies",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                            self?.handleRegulatoryAgencies
                        }),
                    .init(
                        title: "Standards",
                        subtitle: "Track revenue",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                            self?.handleStandards
                        }),
                    .init(
                        title: "Tax Information",
                        subtitle: "Tax Information",
                        icon: UIImage(systemName:"chart.line.uptrend.xyaxis"),
                        selectionColor: .clear,
                        selectionImage: nil,
                        showsSelection: false,
                        onTap: { [weak self] _ in
                            self?.state.selectedReport = .sales
                            self?.handleTaxInformation
                        })
                    
                ],
                allowsMultipleSelection: false
            )
        )
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
                    title: item.title ?? "No Title",
                    subtitle: item.newsCategory?.collection ?? "",
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

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var selectedReport: ReportType?
        var newsItems: [DirectusNewsItem] = []

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
    }

    private enum CellTag: Int {
        case reportTitle = 0
        case continueButton = 1
        case recentActivities = 4
        case category
    }
}
