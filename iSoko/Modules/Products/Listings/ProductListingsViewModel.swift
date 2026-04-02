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

final class ProductListingsViewModel: FormViewModel {

    // MARK: - Callbacks
    var onTapProduct: ((ProductResponseV1) -> Void)?
    var onFavoriteProductToggle: ((Bool, ProductResponseV1) -> Void)?

    // MARK: - Services
    private let productService = NetworkEnvironment.shared.productsService

    // MARK: - State
    private var state = State()

    // Debounce task for search
    private var searchDebounceTask: Task<Void, Never>? = nil

    // MARK: - Init
    init(category: CommodityCategoryResponse? = nil) {
        super.init()
        self.state.category = category
        
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
                showError("Failed to fetch product listings.")
            }
            DispatchQueue.main.async { [weak self] in
                self?.refreshProductListSection()
            }
        }
    }

    // MARK: - Refresh
    override func refresh() {
        state.currentPage = 1
        state.hasMorePages = true
        state.products.removeAll()
        state.filteredProducts.removeAll()
        state.searchText = ""
        fetchData()
    }

    // MARK: - Pagination
    override func loadMoreIfNeeded() {
        guard state.hasMorePages,
              !state.isLoadingMore,
              state.searchText.isEmpty else { return }

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

    // MARK: - Search
    private func setupSearchCallbacks() {
        searchRow.model.onTextChanged = { [weak self] newText in
            self?.handleSearchTextChanged(newText)
        }
    }

    private func handleSearchTextChanged(_ newText: String) {
        state.searchText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchDebounceTask?.cancel()

        searchDebounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
            } catch { return }
            guard let self = self else { return }
            await self.applyLocalFilter(with: self.state.searchText)
        }
    }

    private func applyLocalFilter(with searchText: String) async {
        if searchText.isEmpty {
            await MainActor.run { self.refreshProductListSection() }
            return
        }

        let lower = searchText.lowercased()

        let filtered = await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.state.products.filter {
                    ($0.name?.lowercased().contains(lower) ?? false)
                }
                continuation.resume(returning: results)
            }
        }

        await MainActor.run {
            state.filteredProducts = filtered
            self.refreshProductListSection()
        }
    }

    // MARK: - Update Section
    private func refreshProductListSection() {
        updateSearchRowText()

        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == SectionTag.productList.rawValue
        }) else { return }

        let updatedRow = FeaturedDealsGridFormRow(
            tag: CellTag.productList.rawValue,
            items: makeProductItems(),
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
    private func makeProductItems() -> [FeaturedDealItem] {
        
        let productsToShow = state.searchText.isEmpty
            ? state.products
            : state.filteredProducts

        return productsToShow.map { product in
            
            let imageUrl = product.primaryImageURL ?? ""

            return FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: imageUrl,
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.description ?? "",
                priceText: product.price != nil
                    ? "$\(String(format: "%.2f", product.price!))"
                    : "Price on request",
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapProduct?(product)
                },
                onFavoriteToggle: { [weak self] isFav in
                    self?.onFavoriteProductToggle?(isFav, product)
                }
            )
        }
    }

    // MARK: - API
    private func loadProducts(reset: Bool) async -> Bool {
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
        let title = state.category?.name ?? "All Products"

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
            filterIcon: nil
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
