//
//  AllTradeAssociationViewModel.swift
//  
//
//  Created by Edwin Weru on 21/07/2026.
//

import StorageKit
import DesignSystemKit
import UIKit

final class AllTradeAssociationViewModel: FormViewModel {

    // MARK: - Navigation
    var onAssociationTapped: ((AssociationResponse) -> Void)?

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
                id: 0,
                cells: makeRows()
            )
        ]
    }

    // MARK: - Fetch
    override func fetchData() {
        showLoader()
        Task {
            defer { hideLoader() }
            await fetchAssociations()
        }
    }

    private func fetchAssociations() async {
        do {
            let response = try await associationsService.getAllAssociations(
                page: state.currentPage,
                count: state.itemsPerPage,
                accessToken: state.oauthToken
            )

            state.items = response
            state.hasMorePages = response.count == state.itemsPerPage
            state.currentPage += 1

            DispatchQueue.main.async { [weak self] in
                self?.reloadSection()
            }

        } catch {
            showError(error.localizedDescription)
        }
    }

    // MARK: - Reload
    private func reloadSection() {
        sections[0] = FormSection(id: 0, cells: makeRows())
        onReloadSection?(0)
    }

    // MARK: - Rows
    private func makeRows() -> [FormRow] {
        state.items.enumerated().map { index, item in
            ImageTitleDescriptionBottomRow(
                tag: 2000 + index,
                config: .init(
                    image: nil,
                    title: item.name ?? "",
                    description: item.description ?? "",
                    bottomLabelText: nil,
                    accessoryType: .chevron,
                    onTap: { [weak self] in
                        self?.onAssociationTapped?(item)
                    },
                    isCardStyleEnabled: true
                )
            )
        }
    }

    // MARK: - Load More
    override func loadMoreIfNeeded() {
        guard state.hasMorePages, !state.isLoading else { return }
        state.isLoading = true
        Task {
            await fetchAssociations()
            state.isLoading = false
        }
    }

    // MARK: - State
    private struct State {
        var items: [AssociationResponse] = []
        var currentPage: Int = 1
        var hasMorePages: Bool = true
        var isLoading: Bool = false

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var userProfile: UserProfileResponse? = AppStorage.userProfile
        let itemsPerPage: Int = 20
    }
}
