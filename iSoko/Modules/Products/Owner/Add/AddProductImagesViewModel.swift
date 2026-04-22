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
    var onPreviewImage: ((PickedFile) -> Void)?

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    // MARK: - State
    private var state: State

    // MARK: - Init
    init(_ params: [String: Any]?) {
        self.state = State(params: params)
        super.init()

        sections = makeSections()
        configureUploadHandlers()
    }

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
                headerRow,
                stepIndicatorRow
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
            id: SectionTag.submit.rawValue,
            cells: [
                SpacerFormRow(tag: 20),
                continueButtonRow
            ]
        )
    }

    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        model: TitleDescriptionModel(
            title: "Product Images",
            description: "Upload a primary image and additional images",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .headline,
            descriptionFontStyle: .subheadline
        )
    )

    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 2)
    )

    private lazy var mainImageTitleFormRow = makeTitleRow(
        title: "Primary Product Image",
        description: "This will be the main image shown to customers"
    )

    private lazy var otherImagesTitleFormRow = makeTitleRow(
        title: "Additional Product Images",
        description: "Optional extra images"
    )

    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: UUID().hashValue,
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

    private lazy var primaryImageRow = UploadFormRow(
        tag: CellTag.primaryImage.rawValue,
        config: UploadFormRowConfig(
            style: .dashed,
            title: "Primary Image",
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

    private lazy var imagePreviewRow = ImagePreviewFormRow(
        tag: CellTag.preview.rawValue,
        items: [],
        onRemove: { [weak self] index in
            self?.removeImage(at: index)
        },
        onTap: { [weak self] index in
            guard let self,
                  index < self.state.additionalImages.count else { return }

            self.onPreviewImage?(self.state.additionalImages[index])
        }
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueAction.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )
}

// MARK: - Upload Logic
extension AddProductImagesViewModel {

    private func configureUploadHandlers() {

        primaryImageRow.modelDidUpdate = { [weak self] result in
            guard let self, case .pick = result else { return }

            self.pickFile? { file in
                guard let file else { return }

                self.state.primaryImage = file

                if let data = file.fileData {
                    self.primaryImageRow.selectedImage = UIImage(data: data)
                }

                self.reloadRow(withTag: self.primaryImageRow.tag)
            }
        }

        additionalImagesRow.modelDidUpdate = { [weak self] result in
            guard let self, case .pick = result else { return }

            self.pickFile? { file in
                guard let file else { return }

                self.state.additionalImages.append(file)
                self.updatePreview()
            }
        }
    }

    private func removeImage(at index: Int) {
        guard index < state.additionalImages.count else { return }
        state.additionalImages.remove(at: index)
        updatePreview()
    }

    private func updatePreview() {
        imagePreviewRow.items = state.additionalImages.map {
            ImagePreviewItem(
                image: $0.fileData.flatMap { UIImage(data: $0) },
                fileName: $0.fileName
            )
        }

        reloadRow(withTag: imagePreviewRow.tag)
    }
}

// MARK: - Submit
extension AddProductImagesViewModel {

    private func submit() async {

        guard let params = state.params else {
            print("❌ Missing params")
            return
        }

        let files = [state.primaryImage].compactMap { $0 } + state.additionalImages

        let success = await performNetworkRequest(params: params, files: files)

        if success {
            gotoConfirm?()
        } else {
            print("❌ Upload failed")
        }
    }

    private func performNetworkRequest(
        params: [String: Any],
        files: [PickedFile]
    ) async -> Bool {

        print("📦 Payload:", params)

        do {
            _ = try await bookKeepingService.addProduct(
                parameters: params,
                pickedFiles: files,
                accessToken: state.oauthToken
            )
            return true
        } catch {
            print("❌ Error:", error)
            return false
        }
    }
}

// MARK: - Helpers
extension AddProductImagesViewModel {

    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
}

// MARK: - State
extension AddProductImagesViewModel {

    private struct State {
        var params: [String: Any]?

        var primaryImage: PickedFile?
        var additionalImages: [PickedFile] = []

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
    }
}

// MARK: - Tags
extension AddProductImagesViewModel {

    private enum SectionTag: Int {
        case main
        case mainImage
        case additionalImages
        case submit
    }

    private enum CellTag: Int {
        case header = 1
        case steps
        case primaryImage
        case additionalImages
        case preview
        case continueAction
    }
}
