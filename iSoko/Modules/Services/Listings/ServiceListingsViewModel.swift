//
//  ServiceListingsViewModel.swift
//
//
//  Created by Edwin Weru on 28/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class ServiceListingsViewModel: FormViewModel {

    // MARK: - Callbacks
    var onTapService: ((TradeServiceResponse) -> Void)?
    var onToggleFavorite: ((Bool, TradeServiceResponse) -> Void)?

    // MARK: - Services
    private let servicesService = NetworkEnvironment.shared.servicesService

    // MARK: - State
    private var state = State()

    // Debounce task for search
    private var searchDebounceTask: Task<Void, Never>? = nil

    // MARK: - Init
    init(item: TradeServiceCategoryResponse? = nil) {
        super.init()
        self.state.item = item
        
        Task { @MainActor in
            self.sections = self.makeSections()
        }
        
        setupSearchCallbacks()
    }

    deinit {
        searchDebounceTask?.cancel()
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await loadServices(reset: true)
            if !success {
                showError("Failed to fetch service listings.")
            }
            DispatchQueue.main.async { [weak self] in
                self?.refreshServiceListSection()
            }
        }
    }

    // MARK: - Refresh (Pull-to-Refresh)
    override func refresh() {
        Task { @MainActor in
            state.currentPage = 1
            state.hasMorePages = true
            state.services.removeAll()
            state.filteredServices.removeAll()
            state.searchText = ""
            fetchData()
        }
    }

    // MARK: - Pagination (Load More)
    override func loadMoreIfNeeded() {
        Task { @MainActor in
            guard state.hasMorePages, !state.isLoadingMore, state.searchText.isEmpty else { return }

            state.isLoadingMore = true
            state.currentPage += 1
        }

        Task {
            let success = await loadServices(reset: false)
            await MainActor.run {
                state.isLoadingMore = false
                if success {
                    refreshServiceListSection()
                } else {
                    state.hasMorePages = false
                }
            }
        }
    }

    // MARK: - Search handling
    private func setupSearchCallbacks() {
        searchRow.model.onTextChanged = { [weak self] newText in
            self?.handleSearchTextChanged(newText)
        }
        searchRow.model.didStartEditing = { text in
            print("Started editing search with: \(text)")
        }
        searchRow.model.didEndEditing = { text in
            print("Ended editing search with: \(text)")
        }
        searchRow.model.didTapSearchIcon = {
            print("Search icon tapped")
        }
        searchRow.model.didTapFilterIcon = {
            print("Filter icon tapped")
        }
    }

    private func handleSearchTextChanged(_ newText: String) {
        state.searchText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchDebounceTask?.cancel()

        searchDebounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 300_000_000) // 0.3s debounce
            } catch { return }
            guard let self = self else { return }
            await self.applyLocalFilter(with: self.state.searchText)
        }
    }

    // MARK: - Local Filter (async)
    private func applyLocalFilter(with searchText: String) async {
        if searchText.isEmpty {
            await MainActor.run { self.refreshServiceListSection() }
            return
        }

        let lowercasedSearch = searchText.lowercased()
        let filtered = await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.state.services.filter { service in
                    (service.name?.lowercased().contains(lowercasedSearch) ?? false) ||
                    (service.traderName?.lowercased().contains(lowercasedSearch) ?? false)
                }
                continuation.resume(returning: results)
            }
        }

        await MainActor.run {
            self.state.filteredServices = filtered
            self.refreshServiceListSection()
        }
    }

    // MARK: - Update Section
    private func refreshServiceListSection() {
        updateSearchRowText()

        guard let sectionIndex = sections.firstIndex(where: { $0.id == SectionTag.serviceList.rawValue }) else { return }

        let updatedRow = FeaturedDealsGridFormRow(
            tag: CellTag.serviceList.rawValue,
            items: makeServiceGridItems(),
            columns: 2
        )

        var section = sections[sectionIndex]
        section.cells = [updatedRow]
        sections[sectionIndex] = section
        reloadSection(sectionIndex)
    }

    private func updateSearchRowText() {
        DispatchQueue.main.async {
            if self.searchRow.model.text != self.state.searchText {
                self.searchRow.model.text = self.state.searchText
            }
        }
    }

    // MARK: - Builders
    private func makeServiceGridItems() -> [FeaturedDealItem] {
        let servicesToShow = state.searchText.isEmpty ? state.services : state.filteredServices
        let currency = CountryHelper().currencyString(for: AppStorage.selectedRegion ?? "") ?? "$"

        return servicesToShow.map { service in
            let priceText = service.price != nil ? "\(currency) \(String(format: "%.2f", service.price!))" : "Price on request"
            return FeaturedDealItem(
                id: "\(service.id ?? 0)",
                imageUrl: service.primaryImage ?? "",
                image: UIImage.blankRectangle,
                badgeText: nil,
                title: service.name ?? "Unnamed Service",
                subtitle: service.traderName ?? "",
                priceText: priceText,
                isFavorite: false,
                onTap: { [weak self] in self?.onTapService?(service) },
                onFavoriteToggle: { [weak self] isFav in self?.onToggleFavorite?(isFav, service) }
            )
        }
    }

    // MARK: - API Call
    private func loadServices(reset: Bool) async -> Bool {
        do {
            let response: [TradeServiceResponse]

            if let categoryId = state.item?.id {
                response = try await servicesService.getTradeServicesByCategory(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    categoryId: "\(categoryId)",
                    accessToken: state.guestToken
                )
            } else {
                response = try await servicesService.getAllTradeServices(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.guestToken
                )
            }

            if reset {
                state.services = response
                state.filteredServices.removeAll()
            } else {
                state.services.append(contentsOf: response)
            }

            state.hasMorePages = response.count >= state.itemsPerPage
            return true

        } catch let NetworkError.server(apiError) {
            showError(apiError.message ?? "Unknown server error")
        } catch {
            showError(error.localizedDescription)
        }
        return false
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(id: SectionTag.search.rawValue, title: nil, cells: [searchRow]),
            makeServiceListSection()
        ]
    }

    private func makeServiceListSection() -> FormSection {
        let title = state.item?.id == nil ? "All Services" : (state.item?.name ?? "Services in Category")
        return FormSection(
            id: SectionTag.serviceList.rawValue,
            title: title,
            cells: [productGridRow]
        )
    }

    // MARK: - Rows
    private lazy var searchRow = SearchFormRow(
        tag: CellTag.search.rawValue,
        model: SearchFormModel(
            placeholder: "Search for services",
            keyboardType: .default,
            searchIcon: UIImage(systemName: "magnifyingglass"),
            searchIconPlacement: .right,
            filterIcon: UIImage(systemName: "slider.horizontal.3"),
            didTapSearchIcon: { print("🔍 Search tapped") },
            didTapFilterIcon: { print("⚙️ Filter tapped") }
        )
    )

    private lazy var productGridRow = FeaturedDealsGridFormRow(
        tag: CellTag.serviceList.rawValue,
        items: makeServiceGridItems(),
        columns: 2
    )

    // MARK: - State
    private struct State {
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var services: [TradeServiceResponse] = []
        var filteredServices: [TradeServiceResponse] = []
        var currentPage: Int = 1
        var itemsPerPage: Int = 20
        var hasMorePages: Bool = true
        var isLoadingMore: Bool = false
        var searchText: String = ""
        var item: TradeServiceCategoryResponse? = nil
    }

    // MARK: - Tags
    private enum SectionTag: Int {
        case search = 1
        case serviceList = 2
    }

    private enum CellTag: Int {
        case search = 1
        case serviceList = 2
    }
}
