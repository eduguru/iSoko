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

final class ServiceListingsViewModel: FormViewModel {

    // MARK: - Callbacks
    var onTapProduct: ((TradeServiceResponse) -> Void)?
    var onToggleFavorite: ((Bool, TradeServiceResponse) -> Void)?

    // MARK: - Services
    private let servicesService = NetworkEnvironment.shared.servicesService

    // MARK: - State
    private var state = State()

    // Debounce task for search
    private var searchDebounceTask: Task<Void, Never>? = nil

    // MARK: - Init
    override init() {
        super.init()
        self.sections = makeSections()
        setupSearchCallbacks()
    }

    deinit {
        searchDebounceTask?.cancel()
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await loadProducts(reset: true)
            if !success {
                showError("⚠️ Failed to fetch product listings.")
            }
            DispatchQueue.main.async { [weak self] in
                self?.refreshProductListSection()
            }
        }
    }

    // MARK: - Refresh (Pull-to-Refresh)
    override func refresh() {
        print("🔄 Refresh triggered")
        state.currentPage = 1
        state.hasMorePages = true
        state.products.removeAll()
        state.filteredProducts.removeAll()
        state.searchText = ""
        fetchData() // Re-fetch from start
    }

    // MARK: - Pagination (Load More)
    override func loadMoreIfNeeded() {
        // Disable load more while searching
        guard state.hasMorePages, !state.isLoadingMore, state.searchText.isEmpty else { return }

        state.isLoadingMore = true
        state.currentPage += 1

        Task {
            let success = await loadProducts(reset: false)
            state.isLoadingMore = false

            if success {
                DispatchQueue.main.async { [weak self] in
                    self?.refreshProductListSection()
                }
            } else {
                state.hasMorePages = false
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
        // Save new search term in state
        state.searchText = newText.trimmingCharacters(in: .whitespacesAndNewlines)

        // Cancel previous debounce task
        searchDebounceTask?.cancel()

        // Debounce filtering (300ms delay)
        searchDebounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            } catch {
                // Task was cancelled; just return
                return
            }

            guard let self = self else { return }

            await self.applyLocalFilter(with: self.state.searchText)
        }
    }

    // MARK: - Local Filter (async)
    private func applyLocalFilter(with searchText: String) async {
        if searchText.isEmpty {
            // Show all products when no search
            await MainActor.run {
                self.refreshProductListSection()
            }
            return
        }

        // Filter locally on background queue
        let lowercasedSearch = searchText.lowercased()
        let filtered = await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.state.products.filter { product in
                    (product.name?.lowercased().contains(lowercasedSearch) ?? false) ||
                    (product.traderName?.lowercased().contains(lowercasedSearch) ?? false)
                }
                continuation.resume(returning: results)
            }
        }

        // Update state.filteredProducts with filtered products
        await MainActor.run {
            state.filteredProducts = filtered
            self.refreshProductListSection()
        }
    }

    // MARK: - Update Section with filtered products if searching
    private func refreshProductListSection() {
        // Keep search text updated in searchRow model so it doesn’t reset
        updateSearchRowText()

        guard let sectionIndex = sections.firstIndex(where: { $0.id == SectionTag.productList.rawValue }) else {
            return
        }

        let updatedRow = GridFormRow(
            tag: CellTag.productList.rawValue,
            items: makeProductGridItems(),
            numberOfColumns: 2,
            useCollectionView: false
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
    private func makeProductGridItems() -> [GridItemModel] {
        // If searching, use filteredProducts, else use full products list
        let productsToShow = state.searchText.isEmpty ? state.products : state.filteredProducts

        return productsToShow.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: formattedPrice(for: product),
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapProduct?(product)
                },
                onToggleFavorite: { [weak self] isFav in
                    self?.onToggleFavorite?(isFav, product)
                }
            )
        }
    }

    private func formattedPrice(for product: TradeServiceResponse) -> String? {
        guard let price = product.price else { return nil }
        return "$\(String(format: "%.2f", price))"
    }

    // MARK: - API Call
    private func loadProducts(reset: Bool) async -> Bool {
        do {
            let response = try await servicesService.getAllTradeServices(
                page: state.currentPage,
                count: state.itemsPerPage,
                accessToken: state.accessToken
            )

            if reset {
                state.products = response
                state.filteredProducts.removeAll()
            } else {
                state.products.append(contentsOf: response)
            }

            // If fewer items returned than requested → no more pages
            state.hasMorePages = response.count >= state.itemsPerPage
            print("✅ Fetched page \(state.currentPage) (\(response.count) items)")
            return true

        } catch let NetworkError.server(apiError) {
            print("❌ Server error:", apiError.message ?? "")
            showError(apiError.message ?? "Unknown server error")
        } catch {
            print("❌ Unexpected error:", error.localizedDescription)
            showError(error.localizedDescription)
        }
        return false
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.search.rawValue,
                title: nil,
                cells: [searchRow]
            ),
            makeProductListSection()
        ]
    }

    private func makeProductListSection() -> FormSection {
        FormSection(
            id: SectionTag.productList.rawValue,
            title: "All Services",
            cells: [productGridRow]
        )
    }

    // MARK: - Rows
    private lazy var searchRow = SearchFormRow(
        tag: CellTag.search.rawValue,
        model: SearchFormModel(
            placeholder: "Search for products",
            keyboardType: .default,
            searchIcon: UIImage(systemName: "magnifyingglass"),
            searchIconPlacement: .right,
            filterIcon: UIImage(systemName: "slider.horizontal.3"),
            didTapSearchIcon: { print("🔍 Search tapped") },
            didTapFilterIcon: { print("⚙️ Filter tapped") }
        )
    )

    private lazy var productGridRow = GridFormRow(
        tag: CellTag.productList.rawValue,
        items: makeProductGridItems(),
        numberOfColumns: 2,
        useCollectionView: false
    )

    // MARK: - State
    private struct State {
        var accessToken = AppStorage.accessToken ?? ""
        var products: [TradeServiceResponse] = []
        var filteredProducts: [TradeServiceResponse] = [] // Store filtered products separately
        var currentPage: Int = 1
        var itemsPerPage: Int = 20
        var hasMorePages: Bool = true
        var isLoadingMore: Bool = false
        var searchText: String = ""
    }

    // MARK: - Tags
    private enum SectionTag: Int {
        case search = 1
        case productList = 2
    }

    private enum CellTag: Int {
        case search = 1
        case productList = 2
    }
}
