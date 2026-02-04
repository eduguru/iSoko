//
//  TradeAssociationListingsViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class TradeAssociationListingsViewModel: FormViewModel {

    // MARK: - Navigation
    var goToMoreDetails: (() -> Void)?
    var goToButtonAction: ((String, String, @escaping (Bool) -> Void) -> Void)?

    // MARK: - Services
    private let associationsService = NetworkEnvironment.shared.associationsService

    // MARK: - State
    private var state = State()

    // MARK: - Init
    override init() {
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.header.rawValue,
                cells: [segmentedOptions]
            ),
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: makeImageRows()
            )
        ]
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            await fetchAssociations(for: .approved, reset: true)
            await fetchAssociations(for: .pending, reset: true)
            await fetchAssociations(for: .discover, reset: true)
        }
    }

    // MARK: - Unified Fetch Logic
    private func fetchAssociations(
        for segment: AssociationSegment,
        reset: Bool
    ) async {

        guard var feed = state.feeds[segment], !feed.isLoading else { return }

        feed.isLoading = true
        state.feeds[segment] = feed

        do {
            let response: [AssociationResponse]

            switch segment {
            case .approved:
                response = try await associationsService.getApprovedssociations(
                    page: feed.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.accessToken
                )

            case .pending:
                response = try await associationsService.getAllPendingAssociations(
                    page: feed.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.accessToken
                )

            case .discover:
                response = try await associationsService.getAllAssociations(
                    page: feed.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.accessToken
                )
            }

            if reset {
                feed.items = response
                feed.currentPage = 1
            } else {
                feed.items.append(contentsOf: response)
            }

            feed.hasMorePages = response.count == state.itemsPerPage
            feed.currentPage += 1
            feed.isLoading = false
            state.feeds[segment] = feed

            DispatchQueue.main.async { [weak self] in
                self?.reloadBodySection()
            }

        } catch {
            feed.isLoading = false
            state.feeds[segment] = feed
            showError(error.localizedDescription)
        }
    }

    // MARK: - Segmented Control
    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private func makeOptionsSegmentFormRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Your Associations", "Requested", "Discover"],
                selectedIndex: state.selectedSegment.rawValue,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self,
                          let segment = AssociationSegment(rawValue: index)
                    else { return }

                    self.state.selectedSegment = segment
                    self.reloadBodySection()
                }
            )
        )
    }

    // MARK: - Body Reload
    private func reloadBodySection() {
        sections[1] = FormSection(
            id: Tags.Section.body.rawValue,
            cells: makeImageRows()
        )
        onReloadSection?(Tags.Section.body.rawValue)
    }

    // MARK: - Data Source
    private func currentItems() -> [AssociationResponse] {
        state.feeds[state.selectedSegment]?.items ?? []
    }

    // MARK: - Row Builders
    private func discoverRows() -> [RowItemModel] {
        currentItems().map {
            RowItemModel(
                title: $0.name ?? "",
                description: $0.description ?? "",
                image: .questionCircleIcon,
                bottomButtonTitle: "Join",
                bottomButtonStyle: .primary,
                onBottomButtonTap: { [weak self] in
                    self?.goToButtonAction?("", "") { _ in }
                },
                onTap: { [weak self] in self?.goToMoreDetails?() }
            )
        }
    }

    private func approvedRows() -> [RowItemModel] {
        currentItems().map {
            RowItemModel(
                title: $0.name ?? "",
                description: $0.registrationStatus ?? "",
                image: .settingsGearIcon,
                bottomLabelText: "Member since \($0.foundedIn ?? "")",
                onTap: { [weak self] in self?.goToMoreDetails?() }
            )
        }
    }

    private func pendingRows() -> [RowItemModel] {
        currentItems().map {
            RowItemModel(
                title: $0.name ?? "",
                description: "Awaiting approval",
                image: .legalIcon,
                bottomButtonTitle: "Cancel",
                bottomButtonStyle: .secondary,
                onBottomButtonTap: { [weak self] in
                    self?.goToButtonAction?("", "") { _ in }
                },
                onTap: { [weak self] in self?.goToMoreDetails?() }
            )
        }
    }

    // MARK: - Segment Mapping
    private func makeRowItemsArray() -> [RowItemModel] {
        switch state.selectedSegment {
        case .approved:
            return approvedRows()
        case .pending:
            return pendingRows()
        case .discover:
            return discoverRows()
        }
    }

    // MARK: - Rows
    private func makeImageRows() -> [FormRow] {
        makeRowItemsArray().enumerated().map { index, item in
            ImageTitleDescriptionBottomRow(
                tag: 2000 + index,
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
    }

    // MARK: - Load More
    func loadMoreIfNeeded(at index: Int) {
        guard
            let feed = state.feeds[state.selectedSegment],
            index >= feed.items.count - 3,
            feed.hasMorePages,
            !feed.isLoading
        else { return }

        Task {
            await fetchAssociations(for: state.selectedSegment, reset: false)
        }
    }

    // MARK: - State
    private struct State {
        var selectedSegment: AssociationSegment = .approved
        var accessToken: String = AppStorage.authToken?.accessToken ?? ""
        let itemsPerPage: Int = 20

        var feeds: [AssociationSegment: FeedState] = [
            .approved: FeedState(),
            .pending: FeedState(),
            .discover: FeedState()
        ]
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
    }
    
    enum AssociationSegment: Int {
        case approved = 0
        case pending = 1
        case discover = 2
    }

    struct FeedState {
        var items: [AssociationResponse] = []
        var currentPage: Int = 1
        var hasMorePages: Bool = true
        var isLoading: Bool = false
    }

}
