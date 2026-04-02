//
//  MyProductDetailsViewModel.swift
//
//
//  Created by Edwin Weru on 01/04/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class MyProductDetailsViewModel: FormViewModel {
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: -
    private var state: State
    
    // MARK: -
    init(_ item: StockResponse) {
        state = State(item: item)
        
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        sections.append(makeItemImagesSection())
        sections.append(FormSection(id: 001, title: nil, cells: [aboutProductRow]))
        sections.append(makeSummarySection())
        sections.append(FormSection(id: 0012, title: nil, cells: [priceRow]))
        
        return sections
    }
    
    private func makeItemImagesSection() -> FormSection {
        let images = prepareProductImages()
        
        return FormSection(
            id: SectionTag.productImages.rawValue,
            cells: [
                ProductImageGalleryRow(
                    tag: CellTag.productImages.rawValue,
                    config: ProductImageGalleryConfig(
                        images: images,
                        imageHeight: 140
                    )
                ),
                
                titleRow
            ]
        )
    }
    
    private func makeSummarySection() -> FormSection {
        FormSection(
            id: SectionTag.summary.rawValue,
            title: "Product Information",
            cells: summaryRows
        )
    }
    
    // MARK: - Rows
    private lazy var summaryRows = makeSummaryRows()
    
    private lazy var titleRow = TitleDescriptionFormRow(
        tag: 102,
        model: TitleDescriptionModel(
        title: state.item.name,
        description: "",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
        )
    )
    
    private lazy var aboutProductRow = TitleDescriptionFormRow(
        tag: 101,
        model: TitleDescriptionModel(
        title: "About the Product",
        description: state.item.description ?? "",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left,
        card: .default
        )
    )
    
    private lazy var priceRow = TitleDescriptionFormRow(
        tag: 102,
        model: TitleDescriptionModel(
        title: "Pricing",
        description: "Original Price \n \(state.item.price)",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left,
        showsDivider: true,
        card: .default
        )
    )
    
    private func makeSummaryRows() -> [FormRow] {
        return [
            KeyValueFormRow(
                tag: 1,
                model: KeyValueRowModel(
                    leftText: "Category",
                    rightText: state.item.category?.name ?? "",
                    usesMonospacedDigits: true
                )
            ),
            
            KeyValueFormRow(
                tag: 2,
                model: KeyValueRowModel(
                    leftText: "Unit",
                    rightText: state.item.measurementUnit?.name ?? "",
                    usesMonospacedDigits: true
                )
            ),
            
            KeyValueFormRow(
                tag: 3,
                model: KeyValueRowModel(
                    leftText: "Minimum order quantity",
                    rightText: "\(state.item.minimumOrderQuantity)",
                    showsTopDivider: true,
                    isEmphasized: true,
                    usesMonospacedDigits: true
                )
            )
        ]
    }
    
    private func reloadBodySection(animated: Bool = true) {
        
    }
    
    // MARK: - Image Handling
    private func prepareProductImages() -> [ProductImage] {
        guard let images = state.item.images else {
            return placeholderImages()
        }

        let mapped = images.compactMap { image -> ProductImage? in
            let urlString = image.url
            
            guard image.active == true, let url = URL(string: urlString) else { return nil }

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
    
    // MARK: - Submit
    private func submit() async {
        
    }
    
    // MARK: - State
    private struct State {
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
        
        var item: StockResponse
    }
    
    private enum SectionTag: Int {
        case productImages = 1
        case summary = 2
        
    }
    
    private enum CellTag: Int {
        case productImages = 1
        case summary = 2
        
    }
}


