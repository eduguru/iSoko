//
//  LogisticsServiceProviderDetailsViewModel.swift
//
//
//  Created by Edwin Weru on 22/03/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class LogisticsServiceProviderDetailsViewModel: FormViewModel {
    // MARK: - Callbacks
    
    private var state: State
    
    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    
    init(_ item: LogisitcisServiceProviderResponse) {
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
        guard let profileImageUrl = state.item.displayImage else {
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
    lazy var phoneTitleRow: FormRow = makePhoneRow()
    lazy var emailTitleRow: FormRow = makeEmailRow()
    lazy var websiteTitleRow: FormRow = makeWebsiteRow()
    
    lazy var categotyTitleRow: FormRow = makeCategotyTitleRow()
    lazy var descriptionRow: FormRow = makeDescriptionRow()
    
    private lazy var similarProductsFormRow = HorizontalGridFormRow(tag: 300, items: [])
    
    // MARK: - Row Builders
    
    private func makePhoneRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            title: "Phone Number",
            description: state.item.phoneNumber ?? " N/A",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .callout
        )
    }
    
    private func makeEmailRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            title: "Email",
            description: state.item.email ?? " N/A",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .callout
        )
    }
    
    private func makeWebsiteRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            title: "Website",
            description: state.item.website ?? " N/A",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .body,
            descriptionFontStyle: .callout
        )
    }
    
    private func makeCategotyTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.titleAndDescription.rawValue,
            title: state.item.providerName ?? "",
            description: state.item.locationName ?? "Unnamed Product",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .subheadline,
            descriptionFontStyle: .body
        )
    }
    
    private func makeDescriptionRow() -> FormRow {
        
        let description = state.item.providerName?.isEmpty == false
            ? state.item.providerName!
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
    
    // MARK: - Builders
    
    // MARK: - Network
    
    // MARK: - State
    
    private struct State {
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var item: LogisitcisServiceProviderResponse
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
