//
//  AssociationPublicProductsViewModel.swift
//  
//
//  Created by Edwin Weru on 21/07/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class AssociationPublicProductsViewModel: FormViewModel {

    // MARK: - Navigation
    var goToProductDetails: ((ProductResponseV1) -> Void)?

    // MARK: - Services
    private let associationsService = NetworkEnvironment.shared.associationsService
    private let associationId: Int
    private let oauthToken = AppStorage.oauthToken?.accessToken ?? ""

    private let countryHelper = CountryHelper()

    // MARK: - State
    private var products: [ProductResponseV1] = []

    // MARK: - Init
    init(_ data: AssociationResponse) {
        self.associationId = data.id ?? 0
        super.init()
        sections = makeSections()
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.products.rawValue,
                cells: makeProductsCells()
            )
        ]
    }

    // MARK: - Fetch
    override func fetchData() {
        Task {
            await fetchAssociationProducts()
        }
    }

    private func fetchAssociationProducts() async {

        do {
            let result = try await associationsService.getAssociationProducts(
                id: associationId,
                page: 1,
                count: 20,
                accessToken: oauthToken
            )

            products = result.data ?? []

            reloadProductsSection()

        } catch {
            print("❌ Failed to fetch association products:", error)
        }
    }

    // MARK: - Reload

    private func reloadProductsSection() {

        sections[0] = FormSection(
            id: Tags.Section.products.rawValue,
            cells: makeProductsCells()
        )

        reloadSection(0)
    }

    // MARK: - Products

    private func makeProductsCells() -> [FormRow] {

        let items = makeProductItems()

        guard !items.isEmpty else {
            return []
        }

        return [
            FeaturedDealsGridFormRow(
                tag: Tags.Cells.products.rawValue,
                items: items,
                columns: 2
            ),

            SpacerFormRow(
                tag: 000,
                height: 40
            )
        ]
    }


    private func makeProductItems() -> [FeaturedDealItem] {

        let currency = countryHelper.currencyString(
            for: AppStorage.selectedRegionCode ?? ""
        )

        return products.map { product in

            FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: product.primaryImageURL ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.categoryName ?? product.description ?? "",
                priceText: product.price != nil
                    ? "\(currency) \(String(format: "%.2f", product.price!))"
                    : "Price on request",
                isFavorite: false,

                onTap: { [weak self] in
                    self?.goToProductDetails?(product)
                },

                onFavoriteToggle: { _ in }
            )
        }
    }


    // MARK: - Tags

    enum Tags {

        enum Section: Int {
            case products = 0
        }

        enum Cells: Int {
            case products = 5001
        }
    }
}
