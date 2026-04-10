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

final class AddBookKeepingExpensesViewModel: FormViewModel {
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    
    var gotoConfirm: (() -> Void)?

    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    @MainActor private let countryHelper = CountryHelper()

    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
        configureUploadHandlers()
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
                    uploadAttachmentRow,
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Upload Handlers
    private func configureUploadHandlers() {
        // Logo Upload
        uploadAttachmentRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }

            switch result {
            case .pick:
                self.pickFile? { picked in
                    guard let picked else { return }

                    self.state.attachmentFile = picked

                    if let data = picked.fileData,
                       let image = UIImage(data: data) {
                        self.uploadAttachmentRow.selectedImage = image
                        self.uploadAttachmentRow.selectedDocumentName = nil
                    } else {
                        self.uploadAttachmentRow.selectedDocumentName = picked.fileName
                        self.uploadAttachmentRow.selectedImage = nil
                    }

                    self.reloadRow(withTag: self.uploadAttachmentRow.tag)
                }
            default:
                break
            }
        }
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
                    case CellTag.supplierName.rawValue:
                        self.state.supplierName = newText
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
            rightImage: UIImage(systemName: "calendar"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                let config = DatePickerConfig.year()
                
                self?.goToDateSelection(config) { selectedDate in
                    print(selectedDate)
                }
            }
        )
    )
    
    private lazy var supplierRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Supplier",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: {
                print("open dropdown")
            },
            onActionTap: {
                print("add new / pick contact")
            },
            actionImage: UIImage(systemName: "person.badge.plus"),
            showsActionButton: true
        )
    )
    
    private lazy var categoryRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Category",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: {
                print("open dropdown")
            },
            onActionTap: {
                print("add new / pick")
            },
            actionImage: UIImage(systemName: "person.badge.plus"),
            showsActionButton: true
        )
    )
    
    private lazy var paymentOptionsRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Payment Method",
            placeholder: "Date",
            rightImage: UIImage(systemName: "calendar"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                
            }
        )
    )

    public lazy var uploadAttachmentRow = UploadFormRow(
        tag: CellTag.attachment.rawValue,
        config: UploadFormRowConfig(
            style: .dashed,
            title: "Upload Attachment (Optional)",
            subtitle: ".png, .jpg, .jpeg up to 5MB",
            icon: UIImage(systemName: "photo"),
            borderColor: .lightGray,
            backgroundColor: .clear,
            cornerRadius: 12,
            height: 120
        )
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
            onTextChanged: { newText in
                print("Description changed to: \(newText)")
            },
            onValidationError: { error in
                if let error = error {
                    print("Validation error: \(error)")
                }
            }
        )
    )

    // MARK: - handle selections

    // MARK: - Reload
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Submit
    private func submit() async {

    }

    // MARK: - State
    private struct State {
        var categories: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?

        var dateString: String = ""
        var amount: String = ""
        var supplierName: String = ""
        var description: String = ""
        var date: Date?

        var attachmentFile: PickedFile?

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
        case category = 4
        case date = 5
        case paymentMethod = 6
        case amount = 7
        case supplierName = 8
        case continueButton = 9
        case attachment = 11
        case description = 12
    }
}

