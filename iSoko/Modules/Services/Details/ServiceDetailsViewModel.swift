//
//  ServiceDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 31/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class ServiceDetailsViewModel: FormViewModel {

    private var state: State

    // MARK: - Callbacks
    var onServiceTap: ((TradeServiceResponse) -> Void)?
    var onToggleFavorite: ((TradeServiceResponse, Bool) -> Void)?

    // MARK: - Services
    private let servicesService = NetworkEnvironment.shared.servicesService

    // MARK: - Init
    init(_ service: TradeServiceResponse) {
        self.state = State(service: service)
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await fetchServiceItems()
            if !success {
                print("Failed to fetch similar services.")
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateSimilarServicesSection()
            }
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        let images = prepareServiceImages()
        return [
            FormSection(
                id: Tags.Section.serviceImages.rawValue,
                cells: [
                    ProductImageGalleryRow(
                        tag: Tags.Cells.serviceImages.rawValue,
                        config: ProductImageGalleryConfig(images: images, imageHeight: 140)
                    ),
                    categoryTitleRow,
                    minimumQuantityRow,
                    descriptionRow,
                    quantityRow,
                    makeConfirmButtonRow(),
                    storeProfileRow
                ]
            ),
            similarServicesSection()
        ]
    }

    private func similarServicesSection() -> FormSection {
        FormSection(
            id: Tags.Section.similarServices.rawValue,
            title: "Similar Services",
            cells: [similarServicesFormRow]
        )
    }

    private func updateSimilarServicesSection() {
        guard let index = sections.firstIndex(where: { $0.id == Tags.Section.similarServices.rawValue }) else { return }
        sections[index].cells = [
            HorizontalGridFormRow(
                tag: Tags.Section.similarServices.rawValue,
                items: makeSimilarServicesGridItems()
            )
        ]
        reloadSection(index)
    }

    // MARK: - Image Handling
    private func prepareServiceImages() -> [ProductImage] {
        var images: [ProductImage] = []

        if let primary = state.service.primaryImage, let url = URL(string: primary) {
            images.append(ProductImage(url: url, isFeatured: true))
        }

        let otherImages = (state.service.images ?? [])
            .compactMap { URL(string: $0) }
            .filter { url in !images.contains(where: { $0.url == url }) }
            .map { ProductImage(url: $0, isFeatured: false) }

        images.append(contentsOf: otherImages)
        return images.isEmpty ? placeholderImages() : images
    }

    private func placeholderImages() -> [ProductImage] {
        [ProductImage(url: URL(string: "https://via.placeholder.com/600x400?text=No+Image")!, isFeatured: true)]
    }

    // MARK: - Lazy Rows
    lazy var categoryTitleRow: FormRow = makeCategoryTitleRow()
    lazy var descriptionRow: FormRow = makeDescriptionRow()
    lazy var minimumQuantityRow: FormRow = makeMinimumQuantityRow()
    lazy var storeProfileRow: FormRow = makeStoreProfileRow()
    lazy var quantityRow: FormRow = QuantityFormRow(
        tag: 500,
        title: "Quantity",
        initialValue: 1
    ) { value in
        print("Quantity changed: \(value)")
    }

    private lazy var similarServicesFormRow = HorizontalGridFormRow(tag: 300, items: [])

    // MARK: - Row Builders
    private func makeCategoryTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            model: TitleDescriptionModel(
            title: state.service.categoryName ?? "",
            description: state.service.name ?? "Unnamed Service",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
            )
        )
    }

    private func makeDescriptionRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.categories.rawValue,
            model: TitleDescriptionModel(
            title: state.service.description ?? "No description available",
            description: "",
            maxTitleLines: 20,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .headline
            )
        )
    }

    private func makeMinimumQuantityRow() -> FormRow {
        let minQty = state.service.minimumOrderQuantity ?? 1
        let price = state.service.price ?? 0.0
        let model = ProductSummaryModel(
            title: state.service.name ?? "Unnamed Service",
            rating: 0,
            reviewCount: 0,
            location: state.service.traderName ?? "",
            priceText: state.service.price != nil ? "KES \(String(format: "%.2f", price)) / \(state.service.measurementUnit ?? "unit")" : "Price on request",
            oldPriceText: nil,
            discountText: minQty > 1 ? "Min Qty: \(minQty)" : nil
        )
        return ProductSummaryRow(tag: 101, model: model)
    }

    private func makeStoreProfileRow() -> FormRow {
        let traderName = state.service.traderName ?? "Seller"
        return StoreProfileCardRow(
            tag: 400,
            config: StoreProfileCardConfig(
                image: .blankRectangle,
                title: traderName,
                verifiedImage: nil,
                badges: [],
                trailingButtonTitle: "View Store",
                onTrailingButtonTap: { print("Go to seller: \(traderName)") },
                actions: [
                    .init(title: "WhatsApp", image: UIImage(systemName: "message.fill"), handler: { print("WhatsApp tapped") }),
                    .init(title: "Call", image: UIImage(systemName: "phone.fill"), handler: { print("Call tapped") }),
                    .init(title: "Email", image: UIImage(systemName: "envelope.fill"), handler: { print("Email tapped") })
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
            ) { print("Place order tapped") }
        )
    }

    // MARK: - Grid Items with Callbacks
    private func makeSimilarServicesGridItems() -> [GridItemModel] {
        state.similarService.map { service in
            GridItemModel(
                id: "\(service.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: service.primaryImage ?? "",
                title: service.name ?? "Unnamed Service",
                subtitle: service.traderName ?? "",
                price: service.price != nil ? "KES \(String(format: "%.2f", service.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onServiceTap?(service)
                },
                onToggleFavorite: { [weak self] fav in
                    self?.onToggleFavorite?(service, fav)
                }
            )
        }
    }

    // MARK: - Network
    private func fetchServiceItems() async -> Bool {
        return await fetchData(type: .similarService)
    }

    @discardableResult
    private func fetchData(type: RequestDataType) async -> Bool {
        do {
            switch type {
            case .similarService:
                let categoryId = state.service.categoryId ?? 0
                let response = try await servicesService.getTradeServicesByCategory(
                    page: 1, count: 10, categoryId: "\(categoryId)", accessToken: state.guestToken
                )
                state.similarService = response
                print("✅ Fetched similar services")
            }
            return true
        } catch {
            print("❌ Error fetching \(type):", error)
            return false
        }
    }

    // MARK: - State
    private struct State {
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        var service: TradeServiceResponse
        var similarService: [TradeServiceResponse] = []
    }

    // MARK: - Request Type
    private enum RequestDataType: CustomStringConvertible {
        case similarService
        var description: String { "Similar Services" }
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case serviceImages = 0
            case titleAndDescription = 1
            case categories = 3
            case similarServices = 5
        }
        enum Cells: Int {
            case serviceImages = 0
            case titleAndDescription = 1
            case categories = 3
        }
    }
}
