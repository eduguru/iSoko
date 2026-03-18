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
    // MARK: - Callbacks
    var onProductTap: ((ProductResponseV1) -> Void)?
    var onToggleFavorite: ((ProductResponseV1, Bool) -> Void)?
    
    private var state: State
    
    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    
    init(_ product: ProductResponseV1) {
        self.state = State(product: product)
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await fetchProductItems()
            
            if !success {
                print("⚠️ Failed to fetch product data")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateSimilarProductsSection()
            }
        }
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        let images = prepareProductImages()
        
        return [
            FormSection(
                id: Tags.Section.productImages.rawValue,
                cells: [
                    ProductImageGalleryRow(
                        tag: Tags.Cells.productImages.rawValue,
                        config: ProductImageGalleryConfig(
                            images: images,
                            imageHeight: 140
                        )
                    ),
                    categotyTitleRow,
                    priceRow,
                    minimumQuantityRow,
                    descriptionRow,
                    quantityRow,
                    makeConfirmButtonRow(),
                    storeProfileRow
                ]
            ),
            similarProductsSection()
        ]
    }
    
    private func similarProductsSection() -> FormSection {
        FormSection(
            id: Tags.Section.similarProducts.rawValue,
            title: "Similar Products",
            cells: [similarProductsFormRow]
        )
    }
    
    private func updateSimilarProductsSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.similarProducts.rawValue
        }) else { return }
        
        sections[index].cells = [
            HorizontalGridFormRow(
                tag: Tags.Section.similarProducts.rawValue,
                items: makeSimilarProductsGridItems()
            )
        ]
        
        reloadSection(index)
    }
    
    // MARK: - Image Handling
    private func prepareProductImages() -> [ProductImage] {
        guard let images = state.product.images else {
            return placeholderImages()
        }

        let mapped = images.compactMap { image -> ProductImage? in
            guard
                image.active == true,
                let urlString = image.url,
                let url = URL(string: urlString)
            else { return nil }

            return ProductImage(
                url: url,
                isFeatured: image.primary ?? false
            )
        }

        let sorted = mapped.sorted { $0.isFeatured && !$1.isFeatured }

        return sorted.isEmpty ? placeholderImages() : sorted
    }
    
    private func placeholderImages() -> [ProductImage] {
        [
            ProductImage(
                url: URL(string: "https://via.placeholder.com/600x400?text=No+Image")!,
                isFeatured: true
            )
        ]
    }
    
    // MARK: - Rows
    
    lazy var categotyTitleRow: FormRow = makeCategotyTitleRow()
    lazy var priceRow: FormRow = makePriceRow()
    lazy var descriptionRow: FormRow = makeDescriptionRow()
    lazy var minimumQuantityRow: FormRow = makeMinimumQuantityRow()
    lazy var storeProfileRow: FormRow = makeStoreProfileRow()
    
    private lazy var similarProductsFormRow = HorizontalGridFormRow(tag: 300, items: [])
    
    lazy var quantityRow: FormRow = QuantityFormRow(
        tag: 500,
        title: "Quantity",
        initialValue: 1
    ) { value in
        print("Quantity changed: \(value)")
    }
    
    // MARK: - Row Builders
    
    private func makeCategotyTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            title: state.product.categoryName ?? "",
            description: state.product.name ?? "Unnamed Product",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
    }
    
    private func makePriceRow() -> FormRow {
        
        let priceText: String = {
            if let price = state.product.price {
                return "KES \(String(format: "%.2f", price))"
            }
            return "Price on request"
        }()
        
        return TitleDescriptionFormRow(
            tag: Tags.Cells.price.rawValue,
            title: "\(priceText) / \(state.product.measurementUnit?.name ?? "unit")",
            description: "",
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .callout,
            descriptionFontStyle: .headline
        )
    }
    
    private func makeDescriptionRow() -> FormRow {
        
        let description = state.product.description?.isEmpty == false
            ? state.product.description!
            : "No description available"
        
        return TitleDescriptionFormRow(
            tag: Tags.Cells.categories.rawValue,
            title: description,
            description: "",
            maxTitleLines: 20,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .headline
        )
    }
    
    private func makeMinimumQuantityRow() -> FormRow {
        
        let product = state.product
        
        let priceText: String = {
            if let price = product.price {
                return "KES \(String(format: "%.2f", price))"
            }
            return "Price on request"
        }()
        
        let unit = product.measurementUnit?.name ?? "unit"
        let minQty = product.minimumOrderQuantity ?? 1
        
        let model = ProductSummaryModel(
            title: product.name ?? "Unnamed Product",
            rating: 0,
            reviewCount: 0,
            location: "",
            priceText: "\(priceText) / \(unit)",
            oldPriceText: nil,
            discountText: minQty > 1 ? "Min Qty: \(minQty)" : nil
        )
        
        return ProductSummaryRow(tag: 101, model: model)
    }
    
    private func makeStoreProfileRow() -> FormRow {
        
        let traderName = state.product.traderFullName ?? "Seller"
        
        return StoreProfileCardRow(
            tag: 400,
            config: StoreProfileCardConfig(
                image: .blankRectangle,
                title: traderName,
                verifiedImage: nil,
                badges: [],
                trailingButtonTitle: "View Store",
                onTrailingButtonTap: {
                    print("Go to seller: \(traderName)")
                },
                actions: [
                    .init(
                        title: "WhatsApp",
                        image: UIImage(systemName: "message.fill"),
                        handler: { print("WhatsApp tapped") }
                    ),
                    .init(
                        title: "Call",
                        image: UIImage(systemName: "phone.fill"),
                        handler: { print("Call tapped") }
                    ),
                    .init(
                        title: "Email",
                        image: UIImage(systemName: "envelope.fill"),
                        handler: { print("Email tapped") }
                    )
                ],
                cornerRadius: 20,
                backgroundColor: .systemBackground,
                borderColor: .systemGray5,
                borderWidth: 1
            )
        )
    }
    
    private func makeConfirmButtonRow() -> FormRow {
        ButtonFormRow(
            tag: 1001,
            model: ButtonFormModel(
                title: "Place Order",
                style: .primary,
                size: .large,
                icon: nil,
                fontStyle: .headline,
                hapticsEnabled: true
            ) {
                print("Place order tapped")
            }
        )
    }
    
    // MARK: - Builders
    
    private func makeSimilarProductsGridItems() -> [GridItemModel] {
        state.similarProduct.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: product.primaryImageURL ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderFullName ?? "",
                price: product.price != nil ? "KES \(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    guard let self = self else { return }
                    self.onProductTap?(product)
                },
                onToggleFavorite: { [weak self] fav in
                    guard let self = self else { return }
                    self.onToggleFavorite?(product, fav)
                }
            )
        }
    }
    
    // MARK: - Network
    
    private func fetchProductItems() async -> Bool {
        async let similar = fetchData(type: .similarProduct)
        let results = await [similar]
        return results.allSatisfy { $0 }
    }
    
    @discardableResult
    private func fetchData(type: RequestDataType) async -> Bool {
        do {
            switch type {
                
            case .similarProduct:
                let categoryId = state.product.category?.id ?? 0
                
                let response = try await productsService.getProductsByCategory(
                    page: 1,
                    count: 10,
                    categoryId: "\(categoryId)",
                    accessToken: state.guestToken
                )
                
                self.state.similarProduct = response.data
                
            case .moreOwnerProducts:
                break
            }
            
            return true
            
        } catch {
            print("❌ Error in \(type):", error)
            return false
        }
    }
    
    // MARK: - State
    
    private struct State {
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var product: ProductResponseV1
        var similarProduct: [ProductResponseV1] = []
        var moreOwnerProducts: [ProductResponseV1] = []
    }
    
    // MARK: - Enums
    
    private enum RequestDataType: CustomStringConvertible {
        case similarProduct
        case moreOwnerProducts
        
        var description: String {
            switch self {
            case .similarProduct: return "Similar Products"
            case .moreOwnerProducts: return "More from Seller"
            }
        }
    }
    
    enum Tags {
        enum Section: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
            case similarProducts = 5
        }
        
        enum Cells: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
        }
    }
}
