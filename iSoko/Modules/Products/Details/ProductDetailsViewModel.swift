//
//  ProductDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class ProductDetailsViewModel: FormViewModel {

    private var state: State

    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    
    
    init(_ product: ProductResponse) {
        self.state = State(product: product)
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let productsSuccess = await fetchProductItems()
            
            if !productsSuccess {
                print("⚠️ Failed to fetch one or product types.")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateMoreProductsFromSellerSection()
                self.updateSimilarProductsSection()
            }
        }
    }

    // MARK: - makeSections
    
    private func makeSections() -> [FormSection] {
        let images = prepareProductImages()

        return [
            FormSection(id: Tags.Section.productImages.rawValue, cells: [
                ProductImageGalleryRow(
                    tag: Tags.Cells.productImages.rawValue,
                    config: ProductImageGalleryConfig(
                        images: images,
                        imageHeight: 140
                    )
                ),
                categotyTitleRow,
                priceRow,
                descriptionRow,
                minimumQuantityRow
            ]),
            moreProductsFromSellerSection(),
            similarProductsSection()
            
        ]
    }
    
    private func moreProductsFromSellerSection() -> FormSection {
        return FormSection(
            id: Tags.Section.moreFromThisSeller.rawValue,
            title: "More From This Seller",
            cells: [moreFromThisSellerFormRow]
        )
    }
    
    private func similarProductsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.similarProducts.rawValue,
            title: "Similar Products",
            cells: [similarProductsFormRow]
        )
    }
    
    private func updateMoreProductsFromSellerSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.moreFromThisSeller.rawValue }) else {
            return
        }

        let updatedRow = HorizontalGridFormRow(
            tag: Tags.Section.moreFromThisSeller.rawValue,
            items: makeMoreFromSellerGridItems()
        )

        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    private func updateSimilarProductsSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.similarProducts.rawValue }) else {
            return
        }

        let updatedRow = HorizontalGridFormRow(
            tag: Tags.Section.similarProducts.rawValue,
            items: makeSimilarProductsGridItems()
        )

        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    
    // MARK: - Image Preparation
    
    private func prepareProductImages() -> [ProductImage] {
        var imageSet: [ProductImage] = []

        // Add primary image if valid
        if let primary = state.product.primaryImage,
           let primaryUrl = URL(string: primary) {
            imageSet.append(ProductImage(url: primaryUrl, isFeatured: true))
        }

        // Add other images (excluding duplicates and primary)
        let otherImages = (state.product.images ?? [])
            .compactMap { URL(string: $0) }
            .filter { url in
                // Avoid duplicates (basic check)
                !imageSet.contains(where: { $0.url == url })
            }
            .map { url in
                ProductImage(url: url, isFeatured: false)
            }

        imageSet.append(contentsOf: otherImages)

        // Fallback to placeholder if none exist
        return imageSet.isEmpty ? placeholderImages() : imageSet
    }
    
    private func placeholderImages() -> [ProductImage] {
        return [
            ProductImage(
                url: URL(string: "https://via.placeholder.com/600x400?text=No+Image")!,
                isFeatured: true
            )
        ]
    }

    // MARK: - Lazy Rows

    lazy var categotyTitleRow: FormRow = makeCategotyTitleRow()
    lazy var priceRow: FormRow = makePriceRow()
    lazy var descriptionRow: FormRow = makeDescriptionRow()
    lazy var minimumQuantityRow: FormRow = makeMinimumQuantityRow()

    private func makeCategotyTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            title: "\(state.product.categoryName ?? "")",
            description: "\(state.product.name ?? "")",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
    }

    private func makePriceRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.price.rawValue,
            title: "Price: \(state.product.price ?? 0.0) / \(state.product.measurementUnit ?? "unit")",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .callout,
            descriptionFontStyle: .headline
        )
    }
    
    private func makeDescriptionRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.categories.rawValue,
            title: "\(state.product.description ?? "")",
            description: "",
            maxTitleLines: 20,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .headline
        )
    }
    
    private func makeMinimumQuantityRow() -> FormRow {
        let price = state.product.price ?? 0.0
        let minimumOrderQuantity = state.product.minimumOrderQuantity ?? 0
        
        return TitleDescriptionFormRow(
            tag: Tags.Cells.categories.rawValue,
            title: "Min Qty: \(minimumOrderQuantity)",
            description: "Min Amt: \(Double(minimumOrderQuantity) * price)",
            maxTitleLines: 20,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .footnote,
            descriptionFontStyle: .caption
        )
    }
    
    private lazy var moreFromThisSellerFormRow = HorizontalGridFormRow(
        tag: 300,
        items: []
    )
    
    private lazy var similarProductsFormRow = HorizontalGridFormRow(
        tag: 300,
        items: []
    )
    
    // MARK: - Builders

    private func makeMoreFromSellerGridItems() -> [GridItemModel] {
        return state.moreOwnerProducts.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: product.price != nil ? "$\(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    guard let self = self else { return }
                    // You can emit a callback here if needed
                    print("Tapped product from same seller: \(product.name ?? "")")
                },
                onToggleFavorite: { isFav in
                    print("Favorite toggled (\(isFav)) for product: \(product.name ?? "")")
                }
            )
        }
    }

    private func makeSimilarProductsGridItems() -> [GridItemModel] {
        return state.similarProduct.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: product.price != nil ? "$\(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    guard let self = self else { return }
                    print("Tapped similar product: \(product.name ?? "")")
                },
                onToggleFavorite: { isFav in
                    print("Favorite toggled (\(isFav)) for similar product: \(product.name ?? "")")
                }
            )
        }
    }

    
    //MARK: - Network Calls -
    private func fetchProductItems() async -> Bool {
        async let moreOwnerProducts = fetchData(type: .moreOwnerProducts)
        async let similarProduct = fetchData(type: .similarProduct)

        let results = await [moreOwnerProducts, similarProduct]
        return results.allSatisfy { $0 }
    }
    
    @discardableResult
    private func fetchData(type: RequestDataType) async -> Bool {
        do {
            switch type {
            case .moreOwnerProducts:
                let traderId = state.product.categoryId ?? 0
                let response = try await productsService.getProductsByCategory(page: 1, count: 10, categoryId: "\(traderId)", accessToken: state.guestToken)
                self.state.moreOwnerProducts = response
                print("✅ Fetched Featured Products")

            case .similarProduct:
                let traderId = state.product.categoryId ?? 0
                let response = try await productsService.getProductsByCategory(page: 1, count: 10, categoryId: "\(traderId)", accessToken: state.guestToken)
                self.state.similarProduct = response
                print("✅ Fetched Featured Services")
            }
            
            return true

        } catch let NetworkError.server(apiError) {
            print("❌ API Error in \(type):", apiError.message ?? "")
        } catch {
            print("❌ Unexpected Error in \(type):", error)
        }
        return false
    }
    
    // MARK: - Data Types

    private enum RequestDataType: CustomStringConvertible {
        case similarProduct
        case moreOwnerProducts

        var description: String {
            switch self {
            case .similarProduct: return "Similar Products"
            case .moreOwnerProducts: return "More from this Seller"
            }
        }
    }

    // MARK: - State

    private struct State {
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var isLoggedIn: Bool = true
        var product: ProductResponse
        var similarProduct: [ProductResponse] = []
        var moreOwnerProducts: [ProductResponse] = []
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
            case similarProducts = 5
            case moreFromThisSeller = 6
        }

        enum Cells: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
        }
    }
}
