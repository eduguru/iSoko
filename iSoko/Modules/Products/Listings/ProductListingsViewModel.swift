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

    // MARK: - Initialization
    override init() {
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await loadAllProducts()

            if !success {
                print("⚠️ Failed to fetch product listings.")
            }

            DispatchQueue.main.async { [weak self] in
                self?.refreshProductListSection()
            }
        }
    }

    @discardableResult
    private func loadAllProducts() async -> Bool {
        do {
            let response = try await productService.getAllProducts(
                page: 1,
                count: 20,
                accessToken: state.accessToken
            )
            state.products = response
            print("✅ Successfully fetched all products")
            return true
        } catch let NetworkError.server(apiError) {
            print("❌ Server error while fetching products:", apiError.message ?? "")
        } catch {
            print("❌ Unexpected error while fetching products:", error.localizedDescription)
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

    // MARK: - Form Rows
    private lazy var searchRow = SearchFormRow(
        tag: CellTag.search.rawValue,
        model: SearchFormModel(
            placeholder: "Search for products",
            keyboardType: .default,
            searchIcon: UIImage(systemName: "magnifyingglass"),
            searchIconPlacement: .right,
            filterIcon: UIImage(systemName: "slider.horizontal.3"),
            didTapSearchIcon: { print("🔍 Search tapped") },
            didTapFilterIcon: { print("⚙️ Filter tapped") },
            didStartEditing: { text in print("Started typing: \(text)") },
            didEndEditing: { text in print("Finished editing: \(text)") },
            onTextChanged: { text in print("Search text changed: \(text)") }
        )
    )

    private lazy var productGridRow = GridFormRow(
        tag: CellTag.productList.rawValue,
        items: makeProductGridItems(),
        numberOfColumns: 2,
        useCollectionView: false
    )

    // MARK: - Item Builders
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
