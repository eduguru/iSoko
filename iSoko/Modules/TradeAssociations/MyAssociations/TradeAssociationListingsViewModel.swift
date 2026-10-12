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
    var goToMoreDetails: ((AssociationResponse) -> Void)? = { _ in }
    
    /// (title, message, completion) — the coordinator only presents the confirmation sheet.
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
        showLoader()
        Task {
            defer { hideLoader() } // was outside the Task, so the loader vanished immediately
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
                response = try await associationsService.getApprovedAssociations(
                    id: state.userProfile?.id ?? 0,
                    page: feed.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.oauthToken
                )

            case .pending:
                response = try await associationsService.getAllPendingAssociations(
                    id: state.userProfile?.id ?? 0,
                    page: feed.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.oauthToken
                )

            case .discover:
                response = try await associationsService.getAllAssociations(
                    page: feed.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.oauthToken
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
                segments: [
                    "associations.segment.mine".localized,
                    "associations.segment.requested".localized,
                    "associations.segment.discover".localized
                ],
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
        currentItems().map { item in
            RowItemModel(
                title: item.name ?? "",
                description: item.description ?? "",
                image: nil,
                bottomButtonTitle: "associations.action.join".localized,
                bottomButtonStyle: .primary,
                onBottomButtonTap: { [weak self] in
                    self?.goToButtonAction?(
                        "associations.action.join".localized,
                        "associations.message.confirm_join".localized(with: item.name ?? "")
                    ) { confirmed in
                        if confirmed {
                            self?.enroll(into: item) { success in
                                if success {
                                    print("Enrolled successfully")
                                }
                            }
                        }
                    }
                },
                onTap: { [weak self] in
                    self?.goToMoreDetails?(item)
                }
            )
        }
    }


    private func approvedRows() -> [RowItemModel] {
        currentItems().map { item in
            RowItemModel(
                title: item.name ?? "",
                description: item.registrationStatus ?? "",
                image: nil,
                bottomLabelText: "associations.label.members_count".localized(with: item.members ?? 0),
                onTap: { [weak self] in
                    self?.goToMoreDetails?(item)
                }
            )
        }
    }

    private func pendingRows() -> [RowItemModel] {
        currentItems().map { item in
            RowItemModel(
                title: item.name ?? "",
                description: item.status ?? "associations.status.awaiting_approval".localized,
                image: nil,
                bottomButtonTitle: "common.action.cancel".localized,
                bottomButtonStyle: .secondary,
                onBottomButtonTap: { [weak self] in
                    self?.goToButtonAction?(
                        "common.action.cancel".localized,
                        "associations.message.confirm_cancel".localized(with: item.name ?? "")
                    ) { confirmed in
                        if confirmed {
                            self?.cancelMembership(for: item) { success in
                                if success {
                                    print("Cancelled membership successfully")
                                }
                            }
                        }
                    }
                },
                onTap: { [weak self] in self?.goToMoreDetails?(item) }
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
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
      
        var userDetail: UserDetails? = AppStorage.userDetail
        var userProfile: UserProfileResponse? = AppStorage.userProfile
        
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


// MARK: - Membership Actions
extension TradeAssociationListingsViewModel {

    /// Enroll into an association
    func enroll(into association: AssociationResponse, completion: @escaping (Bool) -> Void) {
        guard let associationId = association.id else {
            completion(false)
            return
        }

        showLoader()
        Task {
            defer { hideLoader() }
            do {
                let _ = try await associationsService.enrollIntoAssociation(
                    associationId: associationId,
                    accessToken: state.oauthToken
                )
                // A new membership starts as Pending: drop it from Discover and refresh the
                // Requested tab (previously only the Approved tab was refreshed, so nothing changed).
                if var discover = state.feeds[.discover] {
                    discover.items.removeAll { $0.id == associationId }
                    state.feeds[.discover] = discover
                }
                await fetchAssociations(for: .pending, reset: true)
                await fetchAssociations(for: .approved, reset: true)
                completion(true)
            } catch {
                showError(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// Cancel membership request
    func cancelMembership(for member: AssociationResponse, comment: String = "User requested cancellation", completion: @escaping (Bool) -> Void) {
        guard let memberId = member.id else {
            completion(false)
            return
        }

        showLoader()
        Task {
            defer { hideLoader() }
            do {
                let _ = try await associationsService.cancelMembership(
                    memberId: memberId,
                    comment: comment,
                    accessToken: state.oauthToken
                )
                // Optionally refresh pending feed
                await fetchAssociations(for: .pending, reset: true)
                completion(true)
            } catch {
                showError(error.localizedDescription)
                completion(false)
            }
        }
    }
}
