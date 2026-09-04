//
//  ProductListingsViewModel.swift
//
//
//  Created by Edwin Weru on 23/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class ProductListingsViewModel: FormViewModel {

    // MARK: - Callbacks
    var onTapProduct: ((ProductResponseV1) -> Void)?
    var onFavoriteProductToggle: ((Bool, ProductResponseV1) -> Void)?
    var goToFilters: ((_ currentFilters: ProductFilters, _ completion: @escaping (ProductFilters) -> Void) -> Void)?

    // MARK: - Services
    private let productService = NetworkEnvironment.shared.productsService
    private let countryHelper  = CountryHelper()

    // MARK: - State
    private var state: State
    private var searchDebounceTask: Task<Void, Never>? = nil

    // MARK: - Init
    init(category: CommodityCategoryResponse? = nil) {
        state = State()
        super.init()
        self.state.category = category
        self.sections = makeSections()
        setupSearchCallbacks()
    }

    deinit { searchDebounceTask?.cancel() }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await loadProducts(reset: true)
            if !success { showError("Failed to fetch product listings.") }
            
            Task { @MainActor in
                refreshProductListSection()
            }
        }
    }

    override func refresh() {
        Task { @MainActor in
            state.currentPage = 1
            state.hasMorePages = true
            state.products.removeAll()
            state.filteredProducts.removeAll()
            state.searchText = ""
            fetchData()
        }
    }

    override func loadMoreIfNeeded() {
        Task { @MainActor in
            guard state.hasMorePages,
                  !state.isLoadingMore,
                  state.searchText.isEmpty else { return }

            state.isLoadingMore = true
            state.currentPage += 1

            let success = await loadProducts(reset: false)
            state.isLoadingMore = false

            if success { refreshProductListSection() }
            else { state.hasMorePages = false }
        }
    }

    // MARK: - Sort (called from VC)
    func applySort(_ option: ProductSortOption) {
        state.sortOption = option
        refreshProductListSection()
    }

    // MARK: - Search
    private func setupSearchCallbacks() {
        searchRow.model.onTextChanged = { [weak self] newText in
            self?.handleSearchTextChanged(newText)
        }
        searchRow.model.didTapFilterIcon = { [weak self] in
            self?.handleFilterTap()
        }
    }

    private func handleSearchTextChanged(_ newText: String) {
        state.searchText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchDebounceTask?.cancel()

        searchDebounceTask = Task { [weak self] in
            do { try await Task.sleep(nanoseconds: 300_000_000) } catch { return }
            guard let self else { return }
            await self.applyLocalFilter(with: self.state.searchText)
        }
    }

    private func applyLocalFilter(with searchText: String) async {
        if searchText.isEmpty {
            refreshProductListSection()
            return
        }

        let lower = searchText.lowercased()
        let filtered = state.products.filter {
            $0.name?.lowercased().contains(lower) ?? false
        }

        state.filteredProducts = filtered
        refreshProductListSection()
    }

    private func handleFilterTap() {
        goToFilters?(state.activeFilters) { [weak self] updatedFilters in
            guard let self else { return }
            self.state.activeFilters = updatedFilters
            self.refreshProductListSection()
        }
    }

    // MARK: - Filtered + Sorted Items
    private var displayItems: [ProductResponseV1] {
        var results = state.searchText.isEmpty ? state.products : state.filteredProducts

        // Apply filters
        let filters = state.activeFilters
        if let minPrice = filters.minPrice {
            results = results.filter { ($0.price ?? 0) >= minPrice }
        }
        if let maxPrice = filters.maxPrice {
            results = results.filter { ($0.price ?? 0) <= maxPrice }
        }
        if let categoryId = filters.categoryId {
            results = results.filter { $0.category?.id == categoryId }
        }

        // Apply sort
        switch state.sortOption {
        case .nameAZ:
            results.sort { ($0.name ?? "") < ($1.name ?? "") }
        case .nameZA:
            results.sort { ($0.name ?? "") > ($1.name ?? "") }
        case .priceLow:
            results.sort { ($0.price ?? 0) < ($1.price ?? 0) }
        case .priceHigh:
            results.sort { ($0.price ?? 0) > ($1.price ?? 0) }
        case .newest:
            break // API already returns newest first
        }

        return results
    }

    // MARK: - Section Update
    private func refreshProductListSection() {
        updateSearchRowText()

        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == SectionTag.productList.rawValue
        }) else { return }

        sections[sectionIndex].cells = [
            FeaturedDealsGridFormRow(
                tag: CellTag.productList.rawValue,
                items: makeProductItems(),
                columns: 2
            )
        ]

        reloadSection(sectionIndex)
    }

    private func updateSearchRowText() {
        if searchRow.model.text != state.searchText {
            searchRow.model.text = state.searchText
        }
    }

    // MARK: - Row Builders
    private func makeProductItems() -> [FeaturedDealItem] {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")

        return displayItems.map { product in
            FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: product.primaryImageURL ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.categoryName ?? "",
                priceText: product.price != nil
                    ? "\(currency) \(String(format: "%.2f", product.price!))"
                    : "Price on request",
                isFavorite: false,
                onTap: { [weak self] in self?.onTapProduct?(product) },
                onFavoriteToggle: { [weak self] isFav in self?.onFavoriteProductToggle?(isFav, product) }
            )
        }
    }

    // MARK: - API
    private func loadProducts(reset: Bool) async -> Bool {
        showLoader()
        defer { hideLoader() }

        do {
            var response: [ProductResponseV1] = []

            if let categoryId = state.category?.id {
                let result = try await productService.getProductsByCategory(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    categoryId: "\(categoryId)",
                    accessToken: state.guestToken
                )
                response = result.data
            } else {
                let result = try await productService.getFeaturedProducts(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.guestToken
                )
                response = result.data
            }

            if reset {
                state.products = response
                state.filteredProducts.removeAll()
            } else {
                state.products.append(contentsOf: response)
            }

            state.hasMorePages = response.count >= state.itemsPerPage
            return true

        } catch {
            showError(error.localizedDescription)
            return false
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(id: SectionTag.search.rawValue, title: nil, cells: [searchRow]),
            makeProductListSection()
        ]
    }

    private func makeProductListSection() -> FormSection {
        let title = state.category?.name?.lowercased().capitalized ?? "All Products"
        return FormSection(
            id: SectionTag.productList.rawValue,
            title: title,
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
            filterIconPlacement: .inside
        )
    )

    private lazy var productGridRow = FeaturedDealsGridFormRow(
        tag: CellTag.productList.rawValue,
        items: makeProductItems(),
        columns: 2
    )

    // MARK: - State
    private struct State {
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        var products: [ProductResponseV1] = []
        var filteredProducts: [ProductResponseV1] = []
        var currentPage: Int = 1
        var itemsPerPage: Int = 20
        var hasMorePages: Bool = true
        var isLoadingMore: Bool = false
        var searchText: String = ""
        var category: CommodityCategoryResponse? = nil
        var sortOption: ProductSortOption = .newest
        var activeFilters: ProductFilters = ProductFilters()
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
