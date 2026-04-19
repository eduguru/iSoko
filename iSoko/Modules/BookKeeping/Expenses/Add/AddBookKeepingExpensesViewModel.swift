//
//  AddBookKeepingExpensesViewModel.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class AddBookKeepingExpensesViewModel: FormViewModel {
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void)
    -> Void = { _, _, _ in }
    
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    var onPreviewImage: ((PickedFile) -> Void)?
            
    var goToAddExpenseCategory: (() -> Void)? = { }
    var goToAddSupplier: (() -> Void)? = { }
    
    var gotoConfirm: (() -> Void)? = { }
    
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    
    @MainActor private let countryHelper = CountryHelper()

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        
        Task { @MainActor in
            sections = makeSections()
            configureUploadHandlers()
        }
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    dateRow,
                    amountInputRow,
                    supplierRow,
                    categoryRow,
                    SpacerFormRow(tag: 20),
                    paymentOptionsRow,
                    descriptionRow,
                    SpacerFormRow(tag: 20),
                    otherImagesTitleFormRow,
                    imagePreviewRow,
                    additionalImagesRow,
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows
    private lazy var amountInputRow = makeInputRow(
        tag: CellTag.amount.rawValue,
        title: "Amount *",
        placeholder: "Enter Amount"
    )

    private lazy var supplierNameInputRow = makeInputRow(
        tag: CellTag.supplierName.rawValue,
        title: "Supplier Name",
        placeholder: "Enter Supplier Name"
    )

    private func makeInputRow(tag: Int, title: String, placeholder: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: .URL
                ),
                validation: ValidationConfiguration(isRequired: false),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }

                    switch tag {
                    case CellTag.amount.rawValue:
                        self.state.amount = newText
                    
                    default:
                        break
                    }
                }
            )
        )
    }
    
    private lazy var dateRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Date",
            placeholder: "Date",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                guard let self else { return }

                let config = DatePickerConfig.year()

                self.goToDateSelection(config) { selectedDate in
                    guard let date = selectedDate else { return }

                    self.state.date = date
                    self.state.dateString = Self.format(date)

                    self.handleDateSelection()
                }
            }
        )
    )
    
    private lazy var supplierRow = DropdownFormRow(
        tag: CellTag.supplier.rawValue,
        config: DropdownFormConfig(
            title: "Supplier",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in
                self?.handleSupplierSelection()
            },
            onActionTap: { [weak self] in
                self?.goToAddSupplier?()
            },
            actionImage: UIImage(systemName: "person.badge.plus"),
            showsActionButton: true
        )
    )
    
    private lazy var categoryRow = DropdownFormRow(
        tag: CellTag.categoryRow.rawValue,
        config: DropdownFormConfig(
            title: "Category",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in
                self?.handleExpenseSelection()
            },
            onActionTap: { [weak self] in
                self?.goToAddExpenseCategory?()
            },
            actionImage: UIImage(systemName: "plus.square"),
            showsActionButton: true
        )
    )
    
    private lazy var paymentOptionsRow = DropdownFormRow(
        tag: CellTag.paymentMethod.rawValue,
        config: DropdownFormConfig(
            title: "Payment Method",
            placeholder: "Method",
            rightImage: UIImage(systemName: "calendar"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handlePaymentsSelection()
            }
        )
    )
    
    private lazy var otherImagesTitleFormRow: FormRow = makeTitleRow(
        title: "Add Receipt Images",
        description: ""
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

    private lazy var additionalImagesRow = UploadFormRow(
        tag: CellTag.attachment.rawValue,
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

    // PREVIEW ROW (with remove + tap)
    private lazy var imagePreviewRow = ImagePreviewFormRow(
        tag: CellTag.preview.rawValue,
        items: [],
        onRemove: { [weak self] index in
            self?.removeImage(at: index)
        },
        onTap: { [weak self] index in
            guard let image = self?.state.additionalImages[index] else { return }
            self?.onPreviewImage?(image)
        }
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
            Task {
                await self?.submit()
            }
        }
    )
    
    // Description input (multiline)  RichDescriptionFormRow LongInputDescriptionFormRow
    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "",
                accessoryImage: nil,
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Description",
            useCardStyle: false,
            cardStyle: .borderAndShadow,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            cardShadowColor: .gray,
            onTextChanged: {[weak self] newText in
                self?.state.description = newText
            },
            onValidationError: { error in
                if let error = error {
                    print("Validation error: \(error)")
                }
            }
        )
    )
    
    // MARK: - Upload Handlers

    private func configureUploadHandlers() {
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

    // MARK: - Actions

    private func removeImage(at index: Int) {
        guard index < state.additionalImages.count else { return }
        state.additionalImages.remove(at: index)
        updatePreview()
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

    // MARK: - handle selections

    // MARK: - Reload // MARK: - Helpers
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Selection Handlers
    private func handleSupplierSelection() {
        goToCommonSelectionOptions(.suppliers(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.supplier = value

            self.supplierRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.supplierRow.tag)
        }
    }
    
    private func handleExpenseSelection() {
        goToCommonSelectionOptions(.expenses(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.categories = value

            self.categoryRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.categoryRow.tag)
        }
    }
    
    private func handlePaymentsSelection() {
        goToCommonSelectionOptions(.paymentOptions(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.paymentMethod = value

            self.paymentOptionsRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.paymentOptionsRow.tag)
        }
    }
    
    private func handleDateSelection() {
        var config = dateRow.config
        config.placeholder = state.dateString
        dateRow.config = config

        reloadRow(withTag: CellTag.date.rawValue)
    }
  
    // MARK: - Submit
    private func submit() async {
        Task {
            let success = await performNetworkRequest()
            
            if !success {
                print("Failed to fetch product data")
            }
            
            DispatchQueue.main.async { [weak self] in  // go to success
                self?.gotoConfirm?()
            }
        }

    }
    
    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        
        let payload: [String: Any] = [
            "categoryId": state.categories?.id ?? "",
            "amount": state.amount,
            "description": state.description,
            "date": state.date.map { $0.toISO8601String() } ?? "",
            "supplierId": state.supplier?.id ?? "",
            "paymentMethodId": state.paymentMethod?.id ?? ""
        ]

        print("📦 payload:", payload)
        
        do {
            let response = try await bookKeepingService.addExpense(parameters: payload, pickedFiles: state.additionalImages, accessToken: state.oauthToken)
                
            return true
            
        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    private static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // MARK: - State
    private struct State {
        var categories: CommonIdNameModel?
        var supplier: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?

        var date: Date?
        var dateString: String = ""

        var amount: String = ""
        var description: String = ""

        var additionalImages: [PickedFile] = []

        private let maxImages = 5

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case date
        case category = 4
        case supplier = 5
        case paymentMethod = 6
        case amount = 7
        case supplierName = 8
        case continueButton = 9
        case attachment = 11
        case description = 12
        case preview
        case categoryRow
    }
}
