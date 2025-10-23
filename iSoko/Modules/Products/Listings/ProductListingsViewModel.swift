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

    // MARK: - Init
    override init() {
        super.init()
        self.sections = makeSections()
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

        fetchData() // Re-fetch from start
    }

    // MARK: - Pagination (Load More)
    override func loadMoreIfNeeded() {
        guard state.hasMorePages, !state.isLoadingMore else { return }

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

    // MARK: - API Call
    private func loadProducts(reset: Bool) async -> Bool {
        do {
            let response = try await productService.getAllProducts(
                page: state.currentPage,
                count: state.itemsPerPage,
                accessToken: state.accessToken
            )

            if reset {
                state.products = response
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
            title: "All Products",
            cells: [productGridRow]
        )
    }

    // MARK: - Update Section
    private func refreshProductListSection() {
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

    // MARK: - Builders
    private func makeProductGridItems() -> [GridItemModel] {
        state.products.map { product in
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

    private func formattedPrice(for product: ProductResponse) -> String? {
        guard let price = product.price else { return nil }
        return "$\(String(format: "%.2f", price))"
    }

    // MARK: - State
    private struct State {
        var accessToken = AppStorage.accessToken ?? ""
        var products: [ProductResponse] = []
        var currentPage: Int = 1
        var itemsPerPage: Int = 20
        var hasMorePages: Bool = true
        var isLoadingMore: Bool = false
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
