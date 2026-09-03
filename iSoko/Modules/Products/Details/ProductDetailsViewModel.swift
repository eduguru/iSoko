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

@MainActor
final class ProductDetailsViewModel: FormViewModel {

    // MARK: - Callbacks
    var onProductTap: ((ProductResponseV1) -> Void)?
    var onViewStoreTap: ((TraderV1) -> Void)?
    var onToggleFavorite: ((ProductResponseV1, Bool) -> Void)?
    var onPlaceOrder: ((PlaceOrderPayload) -> Void)?
    
    private var selectedQuantity: Int

    // MARK: - State
    private var state: State

    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    @MainActor private let countryHelper = CountryHelper()

    // MARK: - Init
    init(_ product: ProductResponseV1) {
        self.state = State(product: product)
        self.selectedQuantity = product.minimumOrderQuantity ?? 1
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            async let similarProducts = fetchSimilarProducts()
            async let reviews = fetchReviews()

            let (didFetchSimilar, _) = await (similarProducts, reviews)

            if !didFetchSimilar {
                print("Failed to fetch similar products")
            }

            await MainActor.run { [weak self] in
                self?.sections = self?.makeSections() ?? []
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
                            imageHeight: 250,
                            placeholderImage: UIImage(named: "blank_rectangle"),
                            fallbackImage: UIImage(named: "blank_rectangle")
                        )
                    ),
                    SpacerFormRow(tag: -0001, height: 16),
                    categotyTitleRow,
                    SpacerFormRow(tag: -0001, height: 16),
                    minimumQuantityRow,
                    SpacerFormRow(tag: -0001, height: 16),
                    quantityRow,
                    SpacerFormRow(tag: -0001, height: 16),
                    instructionsRow,
                    SpacerFormRow(tag: -0001, height: 16),
                    makeConfirmButtonRow(),
                    SpacerFormRow(tag: -0001, height: 16),
                    storeProfileRow,
                    SpacerFormRow(tag: -0001, height: 16),
                ]
            ),

            makeDescriptionReviewsSection(),
            similarProductsSection()
        ]
    }

    // MARK: - Description & Reviews Section
    private func makeDescriptionReviewsSection() -> FormSection {
        var cells: [FormRow] = [descriptionReviewsSegmentRow]

        switch state.selectedDescriptionSegment {
        case 0:
            cells.append(SpacerFormRow(tag: -10, height: 12))
            cells.append(descriptionRow)
        case 1:
            cells.append(SpacerFormRow(tag: -11, height: 12))
            cells.append(contentsOf: makeReviewRows())
        default:
            break
        }

        return FormSection(
            id: Tags.Section.descriptionReviews.rawValue,
            cells: cells
        )
    }

    private func makeReviewRows() -> [FormRow] {
        guard !state.reviews.isEmpty else {
            return [
                TitleDescriptionFormRow(
                    tag: Tags.Cells.emptyReviews.rawValue,
                    model: TitleDescriptionModel(
                        title: "No reviews yet",
                        description: "Be the first to review this product",
                        layoutStyle: .stackedVertical,
                        textAlignment: .center,
                        titleFontStyle: .body,
                        descriptionFontStyle: .subheadline
                    )
                )
            ]
        }

        return state.reviews.enumerated().map { index, review in
            let reviewerName = review.reviewer?.email ?? "Anonymous"
            let rating = review.rating ?? 0
            let stars = String(repeating: "★", count: Int(rating)) +
                        String(repeating: "☆", count: max(0, 5 - Int(rating)))
            let date = review.datetimeCreated.flatMap { formatReviewDate($0) } ?? ""

            return TitleDescriptionFormRow(
                tag: Tags.Cells.review.rawValue + index,
                model: TitleDescriptionModel(
                    title: "\(stars)  \(reviewerName)",
                    description: "\(review.review ?? "")\n\(date)",
                    maxTitleLines: 1,
                    layoutStyle: .stackedVertical,
                    textAlignment: .left,
                    titleFontStyle: .subheadline,
                    descriptionFontStyle: .body
                )
            )
        }
    }

    private lazy var descriptionReviewsSegmentRow: FormRow = makeDescriptionReviewsSegmentRow()

    private func makeDescriptionReviewsSegmentRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Description", "Reviews"],
                selectedIndex: state.selectedDescriptionSegment,
                tag: Tags.Cells.descriptionSegment.rawValue,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self else { return }
                    self.state.selectedDescriptionSegment = index
                    self.reloadDescriptionReviewsSection()
                }
            )
        )
    }

    private func reloadDescriptionReviewsSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.descriptionReviews.rawValue
        }) else { return }

        sections[index].cells = makeDescriptionReviewsSection().cells
        reloadSection(index)
    }

    private func similarProductsSection() -> FormSection {
        FormSection(
            id: Tags.Section.similarProducts.rawValue,
            title: "Similar Products",
            cells: [
                HorizontalGridFormRow(
                    tag: Tags.Section.similarProducts.rawValue,
                    items: makeSimilarProductsGridItems()
                )
            ]
        )
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

            return ProductImage(url: url, isFeatured: image.primary ?? false)
        }

        let sorted = mapped.sorted { $0.isFeatured && !$1.isFeatured }
        return sorted.isEmpty ? placeholderImages() : sorted
    }

    private func placeholderImages() -> [ProductImage] { [] }

    // MARK: - Rows
    lazy var categotyTitleRow: FormRow = makeCategotyTitleRow()
    lazy var priceRow: FormRow = makePriceRow()
    lazy var descriptionRow: FormRow = makeDescriptionRow()
    lazy var minimumQuantityRow: FormRow = makeMinimumQuantityRow()
    lazy var storeProfileRow: FormRow = makeStoreProfileRow()

    lazy var quantityRow: FormRow = QuantityFormRow(
        tag: 500,
        title: "Quantity",
        initialValue: state.product.minimumOrderQuantity ?? 1,
        minimumValue: state.product.minimumOrderQuantity ?? 1
    ) { [weak self] value in
        guard let self else { return }
        self.selectedQuantity = value
    }

    // MARK: - Row Builders
    private func makeCategotyTitleRow() -> FormRow {
        let name = state.product.name ?? "Unnamed Product"
        let category = state.product.categoryName?.lowercased().capitalized ?? "Uncategorized"

        return TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            model: TitleDescriptionModel(
                title: name,
                description: category,
                maxTitleLines: 2,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .headline,
                descriptionFontStyle: .callout
            )
        )
    }

    private func makePriceRow() -> FormRow {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        let priceText: String = {
            guard let price = state.product.price else { return "Price on request" }
            return "\(currency) \(String(format: "%.2f", price))"
        }()
        let unit = state.product.measurementUnit?.name ?? "unit"

        return TitleDescriptionFormRow(
            tag: Tags.Cells.price.rawValue,
            model: TitleDescriptionModel(
                title: "\(priceText) / \(unit)",
                description: "",
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .callout,
                descriptionFontStyle: .subheadline
            )
        )
    }

    private func makeDescriptionRow() -> FormRow {
        let description = state.product.description?.isEmpty == false
            ? state.product.description!
            : "No description available"

        return TitleDescriptionFormRow(
            tag: Tags.Cells.categories.rawValue,
            model: TitleDescriptionModel(
                title: description,
                description: "",
                maxTitleLines: 20,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .body,
                descriptionFontStyle: .subheadline
            )
        )
    }

    private func makeMinimumQuantityRow() -> FormRow {
        let product = state.product
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        let priceText: String = {
            guard let price = product.price else { return "Price on request" }
            return "\(currency) \(String(format: "%.2f", price))"
        }()
        let unit = product.measurementUnit?.name ?? "unit"
        let minQty = product.minimumOrderQuantity ?? 1

        let model = ProductSummaryModel(
            title: "",
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
        let phoneNumber = state.product.trader?.phoneNumber
        let email = state.product.trader?.email
        let whatsappNumber = state.product.trader?.whatsappNumber

        return StoreProfileCardRow(
            tag: 400,
            config: StoreProfileCardConfig(
                image: .blankRectangle,
                title: traderName,
                verifiedImage: nil,
                badges: [],
                trailingButtonTitle: "View Store",
                onTrailingButtonTap: { [weak self] in
                    guard let trader = self?.state.product.trader else { return }
                    self?.onViewStoreTap?(trader)
                },
                actions: [
                    .init(
                        title: "WhatsApp",
                        image: UIImage(systemName: "message.fill"),
                        handler: {
                            guard let number = whatsappNumber,
                                  let url = URL(string: "https://wa.me/\(number)")
                            else { return }
                            UIApplication.shared.open(url)
                        }
                    ),
                    .init(
                        title: "Call",
                        image: UIImage(systemName: "phone.fill"),
                        handler: {
                            guard let number = phoneNumber,
                                  let url = URL(string: "tel://\(number)"),
                                  UIApplication.shared.canOpenURL(url)
                            else { return }
                            UIApplication.shared.open(url)
                        }
                    ),
                    .init(
                        title: "Email",
                        image: UIImage(systemName: "envelope.fill"),
                        handler: {
                            guard let email = email,
                                  let url = URL(string: "mailto:\(email)"),
                                  UIApplication.shared.canOpenURL(url)
                            else { return }
                            UIApplication.shared.open(url)
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

    private lazy var instructionsRow = LongInputDescriptionFormRow(
        tag: Tags.Cells.message.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "",
                accessoryImage: nil,
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Message to the seller",
            useCardStyle: false,
            cardStyle: .borderAndShadow,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            cardShadowColor: .gray,
            onTextChanged: { [weak self] text in
                self?.state.description = text
            }
        )
    )

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
            ) { [weak self] in
                guard let self else { return }
                let product = self.state.product
                let payload = PlaceOrderPayload(
                    product: product,
                    quantity: self.selectedQuantity,
                    minimumQuantity: product.minimumOrderQuantity ?? 1,
                    unitName: product.measurementUnit?.name,
                    unitPrice: product.price,
                    message: state.description
                )
                self.onPlaceOrder?(payload)
            }
        )
    }

    // MARK: - Similar Products
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
                onTap: { [weak self] in self?.onProductTap?(product) },
                onToggleFavorite: { [weak self] fav in self?.onToggleFavorite?(product, fav) }
            )
        }
    }

    // MARK: - Network
    @discardableResult
    private func fetchSimilarProducts() async -> Bool {
        do {
            let categoryId = state.product.category?.id ?? 0
            let response = try await productsService.getProductsByCategory(
                page: 1,
                count: 10,
                categoryId: "\(categoryId)",
                accessToken: state.guestToken
            )
            self.state.similarProduct = response.data
            return true
        } catch {
            print("❌ Error fetching similar products:", error)
            return false
        }
    }

    @discardableResult
    private func fetchReviews() async -> Bool {
        do {
            let productId = "\(state.product.id ?? 0)"
            let reviews = try await productsService.listProductReviews(
                productId: productId,
                accessToken: state.guestToken
            )
            await MainActor.run {
                self.state.reviews = reviews
            }
            return true
        } catch {
            print("❌ Error fetching reviews:", error)
            return false
        }
    }

    // MARK: - Date Helpers
    private func formatReviewDate(_ isoString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: isoString) else { return nil }
        let display = DateFormatter()
        display.dateFormat = "dd MMM yyyy"
        return display.string(from: date)
    }

    // MARK: - State
    private struct State {
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        var description: String = ""
        var product: ProductResponseV1
        var similarProduct: [ProductResponseV1] = []
        var reviews: [ProductReviewResponse] = []
        var selectedDescriptionSegment: Int = 0
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case productImages = 0
            case descriptionReviews = 1
            case similarProducts = 5
        }

        enum Cells: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
            case message = 4
            case descriptionSegment = 5
            case emptyReviews = 6
            case review = 7000
        }
    }
}
