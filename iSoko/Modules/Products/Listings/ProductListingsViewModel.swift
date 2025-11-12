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
    var onTapProduct: ((ProductResponse) -> Void)?
    var onToggleFavorite: ((Bool, ProductResponse) -> Void)?

    // MARK: - Services
    private let productService = NetworkEnvironment.shared.productsService

    // MARK: - State
    private var state = State()

    // Debounce task for search
    private var searchDebounceTask: Task<Void, Never>? = nil

    // MARK: - Init
    init(categoryId: String? = nil) { // ✅ Changed to match service signature
        super.init()
        self.state.categoryId = categoryId
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
        fetchData()
    }

    // MARK: - Pagination (Load More)
    override func loadMoreIfNeeded() {
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

    // MARK: - Local Filter (async)
    private func applyLocalFilter(with searchText: String) async {
        if searchText.isEmpty {
            await MainActor.run { self.refreshProductListSection() }
            return
        }

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

        await MainActor.run {
            state.filteredProducts = filtered
            self.refreshProductListSection()
        }
    }

    // MARK: - Update Section
    private func refreshProductListSection() {
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
                onToggleFavorite: { [weak self] isFav in self?.onToggleFavorite?(isFav, product) }
            )
        }
    }

    private func formattedPrice(for product: ProductResponse) -> String? {
        guard let price = product.price else { return nil }
        return "$\(String(format: "%.2f", price))"
    }

    // MARK: - API Call
    private func loadProducts(reset: Bool) async -> Bool {
        do {
            let response: [ProductResponse]

            if let categoryId = state.categoryId { // ✅ Now using your service signature
                print("📦 Fetching products for categoryId: \(categoryId), page \(state.currentPage)")
                response = try await productService.getProductsByCategory(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    categoryId: categoryId,
                    accessToken: state.accessToken
                )
            } else {
                print("📦 Fetching all products, page \(state.currentPage)")
                response = try await productService.getAllProducts(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    accessToken: state.accessToken
                )
            }

            if reset {
                state.products = response
                state.filteredProducts.removeAll()
            } else {
                state.products.append(contentsOf: response)
            }

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
            FormSection(id: SectionTag.search.rawValue, title: nil, cells: [searchRow]),
            makeProductListSection()
        ]
    }

    private func makeProductListSection() -> FormSection {
        let title = state.categoryId == nil ? "All Products" : "Products in Category"
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
        var products: [ProductResponse] = []
        var filteredProducts: [ProductResponse] = []
        var currentPage: Int = 1
        var itemsPerPage: Int = 20
        var hasMorePages: Bool = true
        var isLoadingMore: Bool = false
        var searchText: String = ""
        var categoryId: String? = nil // ✅ Changed type to match service
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

