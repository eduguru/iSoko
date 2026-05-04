//
//  EditBookKeepingExpensesViewModel.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class EditBookKeepingExpensesViewModel: FormViewModel {
    
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
    
    // MARK: - State
    private var state: State
    
    // MARK: - Init 
    init(expense: ExpenseResponse) {
        self.state = State(expense: expense)
        super.init()
        
        Task { @MainActor in
            state.date = expense.expenseDate.flatMap { Helpers.parseDate($0) } ?? Date()
            state.dateString = Helpers.format(state.date!)
            
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
    
    // MARK: - Prefill 
    private func prefill() {
        
        amountInputRow.model.text = state.amount
        descriptionRow.model.text = state.description
        
        if let supplier = state.supplier {
            supplierRow.config.placeholder = supplier.name ?? ""
        }
        
        if let category = state.categories {
            categoryRow.config.placeholder = category.name ?? ""
        }
        
        if let payment = state.paymentMethod {
            paymentOptionsRow.config.placeholder = payment.name ?? ""
        }
        
        dateRow.config.placeholder = state.dateString
    }
    
    // MARK: - Rows 

    private lazy var amountInputRow = makeInputRow(
        tag: CellTag.amount.rawValue,
        title: "Amount *",
        placeholder: "Enter Amount"
    )

    private func makeInputRow(tag: Int, title: String, placeholder: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: .default
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
    
    // MARK: - Dropdown Rows 
    
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
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handlePaymentsSelection()
            }
        )
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
                    self.state.dateString = Helpers.format(date)
                    
                    self.handleDateSelection()
                }
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
        let success = await performNetworkRequest()
        if success {
            gotoConfirm?()
        }
    }
    
    private func performNetworkRequest() async -> Bool {
        showLoader()
        
        let payload: [String: Any] = [
            "id": state.expense.id,
            "categoryId": state.categories?.id ?? "",
            "amount": state.amount,
            "description": state.description,
            "date": state.date.map { $0.toISO8601String() } ?? "",
            "supplierId": state.supplier?.id ?? "",
            "paymentMethodId": state.paymentMethod?.id ?? ""
        ]
        
        do {
//            _ = try await bookKeepingService.updateExpense(
//                parameters: payload,
//                pickedFiles: state.additionalImages,
//                accessToken: state.oauthToken
//            )
            
            hideLoader()
            return true
            
        } catch {
            hideLoader()
            print("❌ Error:", error)
            return false
        }
    }
    
    // MARK: - Reload // MARK: - Helpers
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
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
    
    // MARK: - State (EXTENDED ONLY)
    private struct State {
        let expense: ExpenseResponse
        
        var categories: CommonIdNameModel?
        var supplier: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?
        
        var date: Date?
        var dateString: String = ""
        
        var amount: String = ""
        var description: String = ""
        
        var additionalImages: [PickedFile] = []
        
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        
        init(expense: ExpenseResponse) {
            self.expense = expense
            
            self.amount = expense.amount.map { "\($0)" } ?? ""
            self.description = expense.description ?? ""
            self.categories = CommonIdNameModel(from: expense.category) ?? CommonIdNameModel(id: -1, name: "Unknown", description: nil)
            self.paymentMethod = CommonIdNameModel(from: expense.paymentMethod) ?? CommonIdNameModel(id: -1, name: "Unknown", description: nil)
            self.supplier = CommonIdNameModel(from: expense.supplier) ?? CommonIdNameModel(id: -1, name: "Unknown", description: nil)
        }
    }
    
    // MARK: - Tags 
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
