//
//  AssociationPublicProductsViewModel.swift
//  
//
//  Created by Edwin Weru on 21/07/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class AssociationPublicProductsViewModel: FormViewModel {

    // MARK: - Navigation
    var goToProductDetails: ((ProductResponseV1) -> Void)?
    var goToFilters: ((_ currentFilters: ProductFilters, _ completion: @escaping (ProductFilters) -> Void) -> Void)?

    // MARK: - Services
    private let associationsService = NetworkEnvironment.shared.associationsService
    private let associationId: Int
    private let oauthToken = AppStorage.oauthToken?.accessToken ?? ""
    private let countryHelper = CountryHelper()

    // MARK: - State
    private var state = State()
    private var searchDebounceTask: Task<Void, Never>?

    // MARK: - Init
    init(_ data: AssociationResponse) {
        self.associationId = data.id ?? 0
        super.init()
        sections = makeSections()
        setupSearchCallbacks()
    }

    deinit { searchDebounceTask?.cancel() }

    // MARK: - Fetch
    override func fetchData() {
        Task { await fetchAssociationProducts() }
    }

    private func fetchAssociationProducts() async {
        showLoader()
        defer { hideLoader() }
        do {
            let result = try await associationsService.getAssociationProducts(
                id: associationId,
                page: 1,
                count: 20,
                accessToken: oauthToken
            )
            state.products = result.data ?? []
            state.filteredProducts.removeAll()
            refreshProductListSection()
        } catch {
            print("❌ Failed to fetch association products:", error)
        }
    }

    // MARK: - Sort
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

    // MARK: - Display Items
    private var displayItems: [ProductResponseV1] {
        var results = state.searchText.isEmpty ? state.products : state.filteredProducts

        let filters = state.activeFilters
        if let minPrice = filters.minPrice {
            results = results.filter { ($0.price ?? 0) >= minPrice }
        }
        if let maxPrice = filters.maxPrice {
            results = results.filter { ($0.price ?? 0) <= maxPrice }
        }

        switch state.sortOption {
        case .nameAZ:    results.sort { ($0.name ?? "") < ($1.name ?? "") }
        case .nameZA:    results.sort { ($0.name ?? "") > ($1.name ?? "") }
        case .priceLow:  results.sort { ($0.price ?? 0) < ($1.price ?? 0) }
        case .priceHigh: results.sort { ($0.price ?? 0) > ($1.price ?? 0) }
        case .newest:    break
        }

        return results
    }

    // MARK: - Section Update
    private func refreshProductListSection() {
        updateSearchRowText()

        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == Tags.Section.products.rawValue
        }) else { return }

        sections[sectionIndex].cells = [
            FeaturedDealsGridFormRow(
                tag: Tags.Cells.products.rawValue,
                items: makeProductItems(),
                columns: 2
            ),
            SpacerFormRow(tag: 000, height: 40)
        ]

        reloadSection(sectionIndex)
    }

    private func updateSearchRowText() {
        if searchRow.model.text != state.searchText {
            searchRow.model.text = state.searchText
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(id: Tags.Section.search.rawValue, title: nil, cells: [searchRow]),
            FormSection(id: Tags.Section.products.rawValue, title: "Products", cells: [productGridRow])
        ]
    }

    // MARK: - Rows
    private lazy var searchRow = SearchFormRow(
        tag: Tags.Cells.search.rawValue,
        model: SearchFormModel(
            placeholder: "Search products",
            keyboardType: .default,
            searchIcon: UIImage(systemName: "magnifyingglass"),
            searchIconPlacement: .right,
            filterIcon: UIImage(systemName: "slider.horizontal.3"),
            filterIconPlacement: .inside
        )
    )

    private lazy var productGridRow = FeaturedDealsGridFormRow(
        tag: Tags.Cells.products.rawValue,
        items: makeProductItems(),
        columns: 2
    )

    private func makeProductItems() -> [FeaturedDealItem] {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        return displayItems.map { product in
            FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: product.primaryImageURL ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.categoryName ?? product.description ?? "",
                priceText: product.price != nil
                    ? "\(currency) \(String(format: "%.2f", product.price!))"
                    : "Price on request",
                isFavorite: false,
                onTap: { [weak self] in self?.goToProductDetails?(product) },
                onFavoriteToggle: { _ in }
            )
        }
    }

    // MARK: - State
    private struct State {
        var products: [ProductResponseV1] = []
        var filteredProducts: [ProductResponseV1] = []
        var searchText: String = ""
        var sortOption: ProductSortOption = .newest
        var activeFilters: ProductFilters = ProductFilters()
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case search = 0
            case products = 1
        }
        enum Cells: Int {
            case search = 0
            case products = 5001
        }
    }
}
