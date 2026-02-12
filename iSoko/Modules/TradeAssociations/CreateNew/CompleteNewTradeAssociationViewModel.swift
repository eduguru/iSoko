//
//  CompleteNewTradeAssociationViewModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class CompleteNewTradeAssociationViewModel: FormViewModel {

    // MARK: - Upload
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?

    // MARK: - Navigation
    var gotoSelectLocation: ((_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)?
    var gotoConfirm: (() -> Void)?

    // MARK: - Country Picker
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    private let countryHelper = CountryHelper()

    // MARK: - Services
    private let associationsService = NetworkEnvironment.shared.associationsService

    // MARK: - Internal State
    private var state = State()

    // MARK: - Init
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
                    headerRow,
                    stepIndicatorRow,
                    phoneDropDownRow,
                    websiteInputRow,
                    instagramInputRow,
                    linkedinInputRow,
                    xInputRow,
                    locationDropdownRow,
                    uploadCertificateRow,
                    uploadLogoRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Upload Handlers
    private func configureUploadHandlers() {

        // Certificate Upload
        uploadCertificateRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }

            switch result {
            case .pick:
                self.pickFile? { picked in
                    guard let picked else { return }

                    self.state.certificate = picked
                    self.uploadCertificateRow.selectedDocumentName = picked.fileName
                    self.uploadCertificateRow.selectedImage = nil
                    self.reloadRow(withTag: self.uploadCertificateRow.tag)
                }
            default:
                break
            }
        }

        // Logo Upload
        uploadLogoRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }

            switch result {
            case .pick:
                self.pickFile? { picked in
                    guard let picked else { return }

                    self.state.logo = picked

                    if let data = picked.fileData,
                       let image = UIImage(data: data) {
                        self.uploadLogoRow.selectedImage = image
                        self.uploadLogoRow.selectedDocumentName = nil
                    } else {
                        self.uploadLogoRow.selectedDocumentName = picked.fileName
                        self.uploadLogoRow.selectedImage = nil
                    }

                    self.reloadRow(withTag: self.uploadLogoRow.tag)
                }
            default:
                break
            }
        }
    }

    // MARK: - Rows

    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 2)
    )

    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        title: "Complete Association Registration",
        description: "Add your contact and location details to help members find your association easily.",
        maxTitleLines: 2,
        layoutStyle: .stackedVertical,
        textAlignment: .left,
        titleFontStyle: .title,
        descriptionFontStyle: .headline
    )

    private lazy var phoneDropDownRow = PhoneDropDownFormRow(
        tag: CellTag.phone.rawValue,
        model: PhoneDropDownModel(
            phoneNumber: "",
            selectedCountry: countryHelper.country(forISO: "KE")!,
            placeholder: "Enter phone number",
            titleText: "Phone Number",
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 5,
                maxLength: 15,
                errorMessageRequired: "Phone number is required",
                errorMessageLength: "Phone number length is invalid"
            ),
            onPhoneChanged: { [weak self] newPhone in
                self?.state.phoneNumber = newPhone
            },
            onCountryTapped: { [weak self] in
                self?.showCountryPicker? { selectedCountry in
                    self?.updatePhoneCountry(selectedCountry)
                }
            },
            onValidationError: { _ in }
        )
    )

    private func updatePhoneCountry(_ newCountry: Country) {
        state.phoneCountry = newCountry

        var model = phoneDropDownRow.model
        model.selectedCountry = newCountry
        phoneDropDownRow.model = model
        reloadRow(withTag: phoneDropDownRow.tag)
    }

    private lazy var websiteInputRow = makeURLInputRow(
        tag: CellTag.website.rawValue,
        title: "Website URL (Optional)",
        placeholder: "Enter website URL"
    )

    private lazy var instagramInputRow = makeURLInputRow(
        tag: CellTag.instagram.rawValue,
        title: "Instagram URL (Optional)",
        placeholder: "Enter Instagram URL"
    )

    private lazy var linkedinInputRow = makeURLInputRow(
        tag: CellTag.linkedin.rawValue,
        title: "LinkedIn URL (Optional)",
        placeholder: "Enter LinkedIn URL"
    )

    private lazy var xInputRow = makeURLInputRow(
        tag: CellTag.xURL.rawValue,
        title: "X URL (Optional)",
        placeholder: "Enter X (Twitter) URL"
    )

    private func makeURLInputRow(tag: Int, title: String, placeholder: String) -> SimpleInputFormRow {
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
                    case CellTag.website.rawValue:
                        self.state.website = newText
                    case CellTag.instagram.rawValue:
                        self.state.instagram = newText
                    case CellTag.linkedin.rawValue:
                        self.state.linkedin = newText
                    case CellTag.xURL.rawValue:
                        self.state.xURL = newText
                    default:
                        break
                    }
                }
            )
        )
    }

    private lazy var locationDropdownRow = DropdownFormRow(
        tag: CellTag.location.rawValue,
        config: DropdownFormConfig(
            title: "Business Location",
            placeholder: state.businessLocation?.name ?? "Select location",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleLocationSelection()
            }
        )
    )

    public lazy var uploadCertificateRow = UploadFormRow(
        tag: CellTag.certificate.rawValue,
        config: UploadFormRowConfig(
            style: .dashed,
            title: "Upload Certificate (Optional)",
            subtitle: ".png, .jpg, .jpeg, .pdf up to 5MB",
            icon: UIImage(systemName: "square.and.arrow.up"),
            borderColor: .lightGray,
            backgroundColor: .clear,
            cornerRadius: 12,
            height: 120
        )
    )

    public lazy var uploadLogoRow = UploadFormRow(
        tag: CellTag.logo.rawValue,
        config: UploadFormRowConfig(
            style: .dashed,
            title: "Upload Logo (Optional)",
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

    // MARK: - Location
    private func handleLocationSelection() {
        gotoSelectLocation? { [weak self] value in
            guard let self, let value else { return }

            self.state.businessLocation = value
            self.locationDropdownRow.config.placeholder = value.name
            self.reloadRow(withTag: self.locationDropdownRow.tag)
        }
    }

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

        let params: [String: Any] = [
            "foundedIn": 2010,
            "name": "Wheat Farmers Association",
            "code": "WFA",
            "countryId": 1,
            "instagram": state.instagram,
            "phoneNumber": state.phoneNumber,
            "x": state.xURL,
            "emailAddress": "wfa@gmail.com",
            "members": 150,
            "website": state.website,
            "description": "An association of wheat farmers",
            "physicalAddress": "123 Wheat St, Nairobi",
            "linkedin": state.linkedin,
            "locationId": "1"
        ]

        do {
            let response = try await associationsService.register(
                association: params,
                logo: state.logo,
                certificate: state.certificate,
                accessToken: state.oauthToken
            )

            gotoConfirm?()

        } catch let NetworkError.server(response) {

            print("🚫 Server error:", response.message ?? "Unknown")

            await MainActor.run {
                state.errorMessage = response.message
                state.fieldErrors = response.errors
            }

        } catch {
            await MainActor.run {
                state.errorMessage = "Something went wrong. Please try again."
            }
        }
    }
    
//    private func applyFieldErrors() {
//        state.fieldErrors?.forEach { error in
//            switch error.field {
//            case "phoneNumber":
//                // phoneDropDownRow.showValidationError(error.message)
//            case "website":
//                // websiteInputRow.showValidationError(error.message)
//            default:
//                break
//            }
//        }
//    }



    // MARK: - State
    private struct State {
        var businessLocation: CommonIdNameModel?

        var phoneNumber: String = ""
        var phoneCountry: Country = CountryHelper().country(forISO: "KE")!

        var website: String = ""
        var instagram: String = ""
        var linkedin: String = ""
        var xURL: String = ""

        var logo: PickedFile?
        var certificate: PickedFile?

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
        case header = 1
        case steps = 2
        case phone = 3
        case website = 4
        case instagram = 5
        case linkedin = 6
        case xURL = 7
        case location = 8
        case continueButton = 9
        case certificate = 10
        case logo = 11
    }
}
