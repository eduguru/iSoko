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
                self.updateSimilarProductsSection()
            }
        }
    }
    
    // MARK: - makeSections
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
                    // categotyTitleRow,
                    // priceRow,
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
        return FormSection(
            id: Tags.Section.similarProducts.rawValue,
            title: "Similar Products",
            cells: [similarProductsFormRow]
        )
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
    lazy var storeProfileRow: FormRow = makeStoreProfileRow()
    private lazy var similarProductsFormRow = HorizontalGridFormRow(tag: 300, items: [] )
    
    
    lazy var quantityRow: FormRow = QuantityFormRow(
        tag: 500,
        title: "Quantity",
        initialValue: 1
    ) { selectedValue in
        print("Quantity changed to: \(selectedValue)")
        // Update state or other logic here
    }
    
    private func makeStoreProfileRow() -> FormRow {
        let traderName = state.product.traderName ?? "Seller"
        
        return StoreProfileCardRow(
            tag: 400,
            config: StoreProfileCardConfig(
                image: .blankRectangle,
                title: traderName,
                verifiedImage: .verified,
                
                badges: [
                    (
                        "East African Trader’s Association",
                        UIColor.systemBlue,
                        UIColor.systemBlue.withAlphaComponent(0.1)
                    ),
                    (
                        "Kenya Exports Council",
                        UIColor.systemBlue,
                        UIColor.systemBlue.withAlphaComponent(0.1)
                    )
                ],
                
                trailingButtonTitle: "View Store",
                onTrailingButtonTap: { [weak self] in
                    guard let self = self else { return }
                    print("Navigate to seller profile: \(traderName)")
                },
                
                actions: [
                    .init(
                        title: "WhatsApp",
                        image: UIImage(systemName: "message.fill"),
                        handler: {
                            print("WhatsApp tapped")
                        }
                    ),
                    .init(
                        title: "Call",
                        image: UIImage(systemName: "phone.fill"),
                        handler: {
                            print("Call tapped")
                        }
                    ),
                    .init(
                        title: "Email",
                        image: UIImage(systemName: "envelope.fill"),
                        handler: {
                            print("Email tapped")
                        }
                    )
                ],
                
                cornerRadius: 20,
                backgroundColor: .systemBackground,
                borderColor: .systemGray5,
                borderWidth: 1
            )
        )
    }
    
    
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
    
    //    private func makeMinimumQuantityRow() -> FormRow {
    //        let price = state.product.price ?? 0.0
    //        let minimumOrderQuantity = state.product.minimumOrderQuantity ?? 0
    //
    //        return TitleDescriptionFormRow(
    //            tag: Tags.Cells.categories.rawValue,
    //            title: "Min Qty: \(minimumOrderQuantity)",
    //            description: "Min Amt: \(Double(minimumOrderQuantity) * price)",
    //            maxTitleLines: 20,
    //            maxDescriptionLines: 0,
    //            titleEllipsis: .none,
    //            descriptionEllipsis: .none,
    //            layoutStyle: .stackedVertical,
    //            textAlignment: .left,
    //            titleFontStyle: .footnote,
    //            descriptionFontStyle: .caption
    //        )
    //    }
    
    private func makeMinimumQuantityRow() -> FormRow {
        let model = ProductSummaryModel(
            title: "Organic Coffee Beans",
            rating: 4.8,
            reviewCount: 154,
            location: "Nairobi, Kenya",
            priceText: "KES 1,699",
            oldPriceText: "1999.00",
            discountText: "21% OFF"
        )
        return ProductSummaryRow(tag: 101, model: model)
    }
    
    
    private func makeConfirmButtonRow() -> FormRow {
        let buttonModel = ButtonFormModel(
            title: "Place Order",
            style: .primary,
            size: .large,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            // self?.gotoConfirm?()
        }
        
        let buttonRow = ButtonFormRow(tag: 1001, model: buttonModel)
        
        return buttonRow
    }
    
    // MARK: - Builders
    
    private func makeMoreFromSellerGridItems() -> [GridItemModel] {
        return state.moreOwnerProducts.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
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
                image: UIImage(named: "blank_rectangle"),
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
        }
        
        enum Cells: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
        }
    }
}
