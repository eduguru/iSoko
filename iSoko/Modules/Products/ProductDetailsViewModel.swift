//
//  ProductDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class ProductDetailsViewModel: FormViewModel {
    
    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - make sections
    private func makeSections() -> [FormSection] {
        
        let imageURl = "https://www.freeproductcompany.org/_next/image?url=%2Fhow_it_works.webp&w=3840&q=75"
        return [
            FormSection(id: 001, cells: [
                ProductImageGalleryRow(
                    tag: 001,
                    config: ProductImageGalleryConfig(
                        images: [
                            ProductImage(url: URL(string: imageURl)!, isFeatured: true),
                            ProductImage(url: URL(string: imageURl)!, isFeatured: false),
                            ProductImage(url: URL(string: imageURl)!, isFeatured: false)
                        ],
                        imageHeight: 140
                    )
                )
            ])
        ]
    }

    // MARK: - Lazy or Computed Rows

    // MARK: - State

    private struct State {
        var isLoggedIn: Bool = true
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }

        enum Cells: Int {
            case headerImage = 0
            case headerTitle = 1
        }
    }
}
