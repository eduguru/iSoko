//
//  StoreProfileViewModel.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class StoreProfileViewModel: FormViewModel {

    // MARK: - Navigation

    var goToProductDetails: ((ProductResponseV1) -> Void)?
    var goToMoreDetails: ((AssociationResponse) -> Void)?

    // MARK: - Dependencies

    private let ordersService = NetworkEnvironment.shared.ordersService
    private let productService = NetworkEnvironment.shared.productsService
    private let countryHelper = CountryHelper()

    // MARK: - State

    private var state: State

    // MARK: - Init

    init(_ data: TraderV1) {
        self.state = State(data: data)
        super.init()

        sections = makeSections()
        reloadBodySection(animated: false)
    }

    // MARK: - Lifecycle

    override func fetchData() {
        Task {
            async let statsTask: Void = fetchStatistics()
            async let productsTask: Void = fetchProducts()

            _ = await (statsTask, productsTask)
        }
    }

    // MARK: - Fetch Statistics

    private func fetchStatistics() async {
        do {
            let stats = try await ordersService.getOrderSummary(
                userId: state.data.id ?? 0,
                accessToken: state.oauthToken
            )

            state.statistics = stats
            updateHeaderSection()

        } catch {
            print("❌ Failed to fetch statistics:", error)
        }
    }

    // MARK: - Fetch Products

    private func fetchProducts() async {
        do {
            let result = try await productService.getProductsByCurrentUser(
                userId: state.data.id ?? 0,
                page: 0,
                count: 10,
                accessToken: state.oauthToken
            )

            state.products = result.data
            reloadBodySection()

        } catch {
            print("❌ Failed to fetch products:", error)
        }
    }

    // MARK: - Section Updates

    private func updateHeaderSection() {
        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == Tags.Section.header.rawValue
        }) else { return }

        sections[sectionIndex].cells[0] = makeHeaderFormRow()

        reloadRow(at: IndexPath(row: 0, section: sectionIndex))
    }

    private func reloadBodySection(animated: Bool = true) {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.body.rawValue
        }) else { return }

        sections[index].cells = currentBodyCells()

        reloadSection(index)
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            cells: [
                makeHeaderFormRow(),
                makeOptionsSegmentFormRow()
            ]
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: currentBodyCells()
        )
    }

    // MARK: - Body Content

    private func currentBodyCells() -> [FormRow] {
        switch state.selectedSegmentIndex {
        case 0:
            return makeProductsCells()

        case 1:
            return makeAboutCells()

        default:
            return []
        }
    }

    // MARK: - Segmented Control

    private func makeOptionsSegmentFormRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: [
                    "Products",
                    "common.label.about".localized
                ],
                selectedIndex: state.selectedSegmentIndex,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self else { return }

                    state.selectedSegmentIndex = index
                    reloadBodySection()
                }
            )
        )
    }

    // MARK: - Header

    private func makeHeaderFormRow() -> FormRow {

        let stats = state.statistics

        let productCount = stats?.productCount ?? 0
        let orderCount = stats?.orderCount ?? 0
        let rating = stats?.averageRating ?? 0
        
        let fullName = (state.data.firstName ?? "") + " " + (state.data.lastName ?? "")

        return StoreHeaderCardFormRow(
            tag: Tags.Cells.header.rawValue,
            config: .init(
                image: .blankRectangle,
                name: fullName,
                location: "Nairobi, Kenya",
                verifiedTitle: "Verified",
                verifiedImage: UIImage(systemName: "checkmark.seal.fill"),
                stats: [
                    .init(
                        value: "\(productCount)",
                        title: "Products"
                    ),
                    .init(
                        value: "\(orderCount)",
                        title: "Orders"
                    ),
                    .init(
                        value: String(format: "%.1f", rating),
                        title: "Rating"
                    )
                ]
            )
        )
    }

    // MARK: - Products

    private func makeProductsCells() -> [FormRow] {

        let items = makeAssociationProductItems()

        guard !items.isEmpty else {
            return [
                SpacerFormRow(tag: 999, height: 40)
            ]
        }

        return [
            FeaturedDealsGridFormRow(
                tag: Tags.Cells.products.rawValue,
                items: items,
                columns: 2
            ),

            SpacerFormRow(
                tag: 1000,
                height: 40
            )
        ]
    }

    private func makeAssociationProductItems() -> [FeaturedDealItem] {

        let currency = countryHelper.currencyString(
            for: AppStorage.selectedRegionCode ?? ""
        )

        return state.products.map { product in

            let priceText: String

            if let price = product.price {
                priceText = "\(currency) \(String(format: "%.2f", price))"
            } else {
                priceText = "Price on request"
            }

            return FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: product.primaryImageURL ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.categoryName ?? product.description ?? "",
                priceText: priceText,
                isFavorite: false,
                onTap: { [weak self] in
                    self?.goToProductDetails?(product)
                },
                onFavoriteToggle: { _ in }
            )
        }
    }

    // MARK: - About

    private func makeAboutCells() -> [FormRow] {
        [
            makeImageTitleDescriptionRow(
                tag: 2001,
                image: .link,
                title: state.data.email ?? "No Email",
                description: ""
            ),

            makeImageTitleDescriptionRow(
                tag: 2002,
                image: .activate,
                title: state.data.phoneNumber ?? "No Phone",
                description: ""
            ),

            makeImageTitleDescriptionRow(
                tag: 2003,
                image: .location,
                title: "common.label.address_placeholder".localized,
                description: ""
            ),

            SpacerFormRow(
                tag: 3000,
                height: 16
            ),

            makeBodyTextRow()
        ]
    }

    private func makeBodyTextRow() -> FormRow {
        RichDescriptionFormRow(
            tag: 3001,
            model: RichDescriptionModel(
                title: "",
                htmlDescription: "dest 1",
                textAlignment: .left
            )
        )
    }

    // MARK: - Shared Row Builder

    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage,
        title: String,
        description: String
    ) -> FormRow {

        ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: image,
                imageStyle: .rounded,
                title: title,
                description: description,
                accessoryType: .none,
                onTap: nil,
                isCardStyleEnabled: true
            )
        )
    }
}

// MARK: - State

private extension StoreProfileViewModel {

    struct State {

        var data: TraderV1
        var statistics: StatisticsResponse?

        var selectedSegmentIndex: Int = 0
        var products: [ProductResponseV1] = []

        var userProfile: UserProfileResponse? = AppStorage.userProfile

        var oauthToken: String {
            AppStorage.oauthToken?.accessToken ?? ""
        }
    }
}

// MARK: - Tags

extension StoreProfileViewModel {

    enum Tags {

        enum Section: Int {
            case header = 0
            case body = 1
        }

        enum Cells: Int {
            case header = 100
            case products = 101
        }
    }
}
