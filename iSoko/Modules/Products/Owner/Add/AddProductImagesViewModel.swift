//
//  AddProductImagesViewModel.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class AddProductImagesViewModel: FormViewModel {

    // MARK: - Upload
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?

    // MARK: - Navigation
    var gotoConfirm: (() -> Void)?

    // MARK: - State
    private var state = State()

    // MARK: - Init
    override init() {
        super.init()

        Task { @MainActor in
            sections = makeSections()
            configureUploadHandlers()
        }
    }

    // MARK: - Sections
    
    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeMainImageSection(),
            makeOtherImagesSection(),
            makeSubmitSection()
        ]
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: SectionTag.main.rawValue,
            cells: [
                SpacerFormRow(tag: 20),
                headerRow
            ]
        )
    }
    
    private func makeMainImageSection() -> FormSection {
        FormSection(
            id: SectionTag.mainImage.rawValue,
            cells: [
                mainImageTitleFormRow,
                SpacerFormRow(tag: 20),
                primaryImageRow
            ]
        )
    }
    
    private func makeOtherImagesSection() -> FormSection {
        FormSection(
            id: SectionTag.additionalImages.rawValue,
            cells: [
                otherImagesTitleFormRow,
                SpacerFormRow(tag: 20),
                imagePreviewRow,
                additionalImagesRow
            ]
        )
    }
    
    private func makeSubmitSection() -> FormSection {
        FormSection(
            id: SectionTag.continueButton.rawValue,
            cells: [
                SpacerFormRow(tag: 20),
                continueButtonRow
            ]
        )
    }

    // MARK: - Header

    private lazy var mainImageTitleFormRow: FormRow = makeTitleRow(
        title: "Primary Product Image",
        description: "This will be the main image shown to customers"
    )

    private lazy var otherImagesTitleFormRow: FormRow = makeTitleRow(
        title: "Additional Product Images",
        description: "Upload more images to showcase your product (Optional)"
    )

    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        model: TitleDescriptionModel(
            title: "Product Images",
            description: "Upload a primary image and additional images to showcase your product",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
    )

    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: UUID().hashValue, // ✅ avoid duplicate tag bug
            model: TitleDescriptionModel(
                title: title,
                description: description,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .body,
                descriptionFontStyle: .subheadline
            )
        )
    }

    // MARK: - Rows

    private lazy var primaryImageRow = UploadFormRow(
        tag: CellTag.primaryImage.rawValue,
        config: UploadFormRowConfig(
            style: .dashed,
            title: "Primary Product Image",
            subtitle: "",
            icon: UIImage(systemName: "photo"),
            borderColor: .lightGray,
            backgroundColor: .clear,
            cornerRadius: 12,
            height: 120
        )
    )

    private lazy var additionalImagesRow = UploadFormRow(
        tag: CellTag.additionalImages.rawValue,
        config: UploadFormRowConfig(
            style: .dashed,
            title: "Add Image",
            subtitle: "",
            icon: UIImage(systemName: "plus"),
            borderColor: .lightGray,
            backgroundColor: .clear,
            cornerRadius: 12,
            height: 100
        )
    )

    // PREVIEW ROW
    private lazy var imagePreviewRow = ImagePreviewFormRow(
        tag: CellTag.preview.rawValue,
        items: []
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
    )

    // MARK: - Upload Handlers

    private func configureUploadHandlers() {

        // PRIMARY IMAGE
        primaryImageRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }

            if case .pick = result {
                self.pickFile? { picked in
                    guard let picked else { return }

                    self.state.primaryImage = picked

                    if let data = picked.fileData,
                       let image = UIImage(data: data) {
                        self.primaryImageRow.selectedImage = image
                    }

                    self.reloadRow(withTag: self.primaryImageRow.tag)
                }
            }
        }

        // ADDITIONAL IMAGES (ARRAY)
        additionalImagesRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }

            if case .pick = result {
                self.pickFile? { picked in
                    guard let picked else { return }

                    self.state.additionalImages.append(picked)
                    self.updatePreview()
                }
            }
        }
    }

    // MARK: - Preview Sync

    private func updatePreview() {
        imagePreviewRow.items = state.additionalImages.map { file in
            ImagePreviewItem(
                image: file.fileData.flatMap { UIImage(data: $0) },
                fileName: file.fileName
            )
        }

        reloadRow(withTag: imagePreviewRow.tag)
    }

    // MARK: - Helpers

    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - State

    private struct State {
        var primaryImage: PickedFile?
        var additionalImages: [PickedFile] = []
    }

    // MARK: - Tags

    private enum SectionTag: Int {
        case main
        case mainImage
        case additionalImages
        case continueButton
    }

    private enum CellTag: Int {
        case header = 1
        case primaryImage
        case additionalImages
        case preview
        case continueButton
    }
}
