//
//  TradeServiceProviderDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 22/03/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class TradeServiceProviderDetailsViewModel: FormViewModel {
    // MARK: - Callbacks
    var onProductTap: ((ProductResponseV1) -> Void)?
    var onToggleFavorite: ((ProductResponseV1, Bool) -> Void)?
    
    private var state: State
    
    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    
    init(_ item: ServiceProviderResponse) {
        self.state = State(item: item)
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        
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
                    descriptionRow,
                ]
            ),
            FormSection(
                id: Tags.Section.titleAndDescription.rawValue,
                title: "Contacts",
                cells: [
                    phoneTitleRow,
                    emailTitleRow,
                    websiteTitleRow
                ]
            )
        ]
    }
    
    // MARK: - Image Handling
    private func prepareProductImages() -> [ProductImage] {
        guard let profileImageUrl = state.item.profileImageUrl else {
            return placeholderImages()
        }

        let mapped = profileImageUrl.compactMap { image -> ProductImage? in
            guard
                let url = URL(string: profileImageUrl)
            else { return nil }

            return ProductImage(
                url: url,
                isFeatured: false
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
    lazy var descriptionRow: FormRow = makeDescriptionRow()
    lazy var phoneTitleRow: FormRow = makePhoneRow()
    lazy var emailTitleRow: FormRow = makeEmailRow()
    lazy var websiteTitleRow: FormRow = makeWebsiteRow()
    
    private lazy var similarProductsFormRow = HorizontalGridFormRow(tag: 300, items: [])

    
    // MARK: - Row Builders
    
    private func makeCategotyTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            model: TitleDescriptionModel(
            title: state.item.organization,
            description: state.item.serviceProviderType ?? "Unnamed Product",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
            )
        )
    }
    
    private func makeDescriptionRow() -> FormRow {
        
        let description = state.item.description?.isEmpty == false
            ? state.item.description!
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
            descriptionFontStyle: .headline
            )
        )
    }
    
    private func makePhoneRow() -> FormRow {
        let phoneNumbersString = state.item.phoneNumbers?
            .joined(separator: " / ") ?? "N/A"
        
        return TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            model: TitleDescriptionModel(
            title: "Phone Number",
            description: phoneNumbersString,
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .callout
            )
        )
    }
    
    private func makeEmailRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            model: TitleDescriptionModel(
            title: "Email",
            description: state.item.organizationEmail ?? " N/A",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .callout
            )
        )
    }
    
    private func makeWebsiteRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            model: TitleDescriptionModel(
            title: "Website",
            description: state.item.website ?? " N/A",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .callout
            )
        )
    }
    
    // MARK: - Builders
    
    // MARK: - Network
    
    // MARK: - State
    
    private struct State {
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var item: ServiceProviderResponse
        var similarProduct: [ProductResponseV1] = []
        var moreOwnerProducts: [ProductResponseV1] = []
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
