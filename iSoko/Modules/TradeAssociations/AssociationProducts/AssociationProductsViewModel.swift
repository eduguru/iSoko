//
//  AssociationProductsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class AssociationProductsViewModel: FormViewModel {

    var goToProductDetails: ((ProductResponseV1) -> Void)?
    var goToMoreDetails: ((AssociationResponse) -> Void)?
    
    private var state: State
    private let directusService = DirectusTokenService()
    private let associationsService = NetworkEnvironment.shared.associationsService
    private let countryHelper = CountryHelper()

    init(_ data: AssociationResponse) {
        state = State(data: data)
        super.init()
        self.sections = makeSections()
        reloadBodySection(animated: false)
    }

    override func fetchData() {
        Task {
            await fetchAssociationProducts()
        }
    }

    // MARK: - Fetch

    private func fetchAssociationProducts() async {
        let id = state.data.id ?? 0
        do {
            let result = try await associationsService.getAssociationProducts(
                id: id,
                page: 1,
                count: 20,
                accessToken: state.oauthToken
            )
            state.associationProducts = result.data ?? []

            DispatchQueue.main.async { [weak self] in
                self?.updateBodySection()
            }

        } catch {
            print("❌ Failed to fetch association products:", error)
        }
    }

    // MARK: - Update Section

    private func updateBodySection() {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.body.rawValue
        }) else { return }

        switch state.selectedSegmentIndex {
        case 0:
            sections[index].cells = makeProductsCells()
        case 1:
            sections[index].cells = makeAboutCells()
        default:
            sections[index].cells = []
        }

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
                associationsHeader,
                segmentedOptions
            ]
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: []
        )
    }

    // MARK: - Body Reload

    private func reloadBodySection(animated: Bool = true) {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.body.rawValue
        }) else { return }

        switch state.selectedSegmentIndex {
        case 0:
            sections[index].cells = makeProductsCells()
        case 1:
            sections[index].cells = makeAboutCells()
        default:
            sections[index].cells = []
        }

        reloadSection(index)
    }

    // MARK: - Lazy Rows

    private lazy var segmentedOptions = makeOptionsSegmentFormRow()
    private lazy var associationsHeader = makeAssociationsHeaderFormRow()

    // MARK: - Segmented Control

    private func makeOptionsSegmentFormRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Products", "common.label.about".localized],
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
                    self.state.selectedSegmentIndex = index
                    self.reloadBodySection(animated: true)
                }
            )
        )
    }

    // MARK: - Header

    private func makeAssociationsHeaderFormRow() -> FormRow {
        AssociationHeaderFormRow(
            tag: 001001,
            model: AssociationHeaderModel(
                title: state.data.name ?? "",
                subtitle: "Founded in " + (state.data.foundedIn ?? "00"),
                desc: "\(state.data.members ?? 0)" + " Members",
                icon: .blankRectangle,
                cardBackgroundColor: .white,
                cardRadius: 0
            )
        )
    }

    // MARK: - Products (segment 0)

    private func makeProductsCells() -> [FormRow] {
        let items = makeAssociationProductItems()

        guard !items.isEmpty else { return [] }

        return [
            FeaturedDealsGridFormRow(
                tag: Tags.Cells.products.rawValue,
                items: items,
                columns: 2
            ),
            SpacerFormRow(tag: 000, height: 40)
        ]
    }

    private func makeAssociationProductItems() -> [FeaturedDealItem] {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")

        return state.associationProducts.map { product in
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

    // MARK: - About (segment 1)

    private lazy var bodyText: FormRow = makeBodyTextRow()
    private func makeBodyTextRow() -> FormRow {
        RichDescriptionFormRow(
            tag: 3001,
            model: RichDescriptionModel(
                title: "",
                htmlDescription: state.data.description ?? "",
                textAlignment: .left
            )
        )
    }

    private func makeAboutCells() -> [FormRow] {
        [
            makeImageTitleDescriptionRow(
                tag: 2001,
                image: .link,
                title: state.data.emailAddress ?? "email",
                description: ""
            ),
            makeImageTitleDescriptionRow(
                tag: 2002,
                image: .activate,
                title: state.data.phoneNumber ?? "phoneNumber",
                description: ""
            ),
            makeImageTitleDescriptionRow(
                tag: 2003,
                image: .location,
                title: state.data.physicalAddress ?? "common.label.address_placeholder".localized,
                description: ""
            ),
            SpacerFormRow(tag: -0001, height: 16),
            makeBodyTextRow()
        ]
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

    // MARK: - State

    private struct State {
        var selectedSegmentIndex: Int = 0
        var data: AssociationResponse
        var associationProducts: [ProductResponseV1] = []
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body   = 1
        }
        enum Cells: Int {
            case products = 5001
        }
    }
}
