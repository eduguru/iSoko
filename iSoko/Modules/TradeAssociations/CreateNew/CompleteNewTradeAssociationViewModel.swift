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

@MainActor
final class CompleteNewTradeAssociationViewModel: FormViewModel {
    
    // MARK: - Callbacks
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    var gotoConfirm: (() -> Void)?
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    
    private let associationsService = NetworkEnvironment.shared.associationsService
    private let countryHelper = CountryHelper()
    
    // MARK: - Internal State
    private var state = State()
    
    // MARK: - Init
    init(_ data: [String: Any]) {
        super.init()
        
        mapStep1Data(data)
        Task { @MainActor in
            sections = makeSections()
            configureUploadHandlers()
        }
    }
    
    // MARK: - Map Step 1 Data
    private func mapStep1Data(_ data: [String: Any]) {
        // Association Name
        if let name = data["name"] as? String {
            state.associationName = name
        }
        
        // Association Code
        if let code = data["code"] as? String {
            state.code = code
        }
        
        // Association Code
        if let countryId = data["countryId"] as? Int {
            state.countryId = countryId
        }

        // Association Description
        if let description = data["description"] as? String {
            state.associationDescription = description
        }

        // Number of Members (can come as String or Int)
        if let members = data["members"] as? Int {
            state.members = members
        } else if let membersString = data["members"] as? String,
                  let membersInt = Int(membersString) {
            state.members = membersInt
        }

        // Founded Year (ensure it’s an Int)
        if let foundedIn = data["foundedIn"] as? Int {
            state.foundedIn = foundedIn
        } else if let foundedInString = data["foundedIn"] as? String,
                  let foundedInInt = Int(foundedInString) {
            state.foundedIn = foundedInInt
        } else if let foundedDate = data["foundedIn"] as? Date {
            state.foundedIn = foundedDate.getComponent(.year)
        }

        // Debug log
        print("Mapped Step 1 data: \(state)")
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    headerRow,
                    stepIndicatorRow,
                    phoneDropDownRow,
                    emailInputRow,
                    websiteInputRow,
                    instagramInputRow,
                    linkedinInputRow,
                    xInputRow,
                    locationRow,
                    uploadCertificateRow,
                    uploadLogoRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }
    
    // MARK: - Rows
    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 2)
    )
    
    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        model: TitleDescriptionModel(
            title: "Complete Association Registration",
            description: "Add contact and location details to help members find your association."
        )
    )
    
    private lazy var phoneDropDownRow = PhoneDropDownFormRow(
        tag: CellTag.phone.rawValue,
        model: PhoneDropDownModel(
            phoneNumber: "",
            selectedCountry: countryHelper.country(forISO: "KE")!,
            placeholder: "Enter phone number",
            titleText: "Phone Number",
            onPhoneChanged: { [weak self] text in self?.state.phoneNumber = text },
            onCountryTapped: { [weak self] in
                self?.showCountryPicker? { country in
                    self?.state.phoneCountry = country
                }
            }
        )
    )
    
    private lazy var emailInputRow = makeURLInputRow(tag: CellTag.email.rawValue, title: "Email Address")
    private lazy var websiteInputRow = makeURLInputRow(tag: CellTag.website.rawValue, title: "Website URL")
    private lazy var instagramInputRow = makeURLInputRow(tag: CellTag.instagram.rawValue, title: "Instagram URL")
    private lazy var linkedinInputRow = makeURLInputRow(tag: CellTag.linkedin.rawValue, title: "LinkedIn URL")
    private lazy var xInputRow = makeURLInputRow(tag: CellTag.xURL.rawValue, title: "X (Twitter) URL")
    
    private lazy var locationRow = makeURLInputRow(tag: CellTag.location.rawValue, title: "Business Location")
    
    private func makeURLInputRow(tag: Int, title: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(placeholder: title),
                validation: ValidationConfiguration(isRequired: false),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] text in
                    guard let self else { return }
                    
                    switch tag {
                    case CellTag.website.rawValue: self.state.website = text
                    case CellTag.instagram.rawValue: self.state.instagram = text
                    case CellTag.linkedin.rawValue: self.state.linkedin = text
                    case CellTag.xURL.rawValue: self.state.xURL = text
                    case CellTag.location.rawValue: self.state.physicalAddress = text
                    case CellTag.email.rawValue: self.state.email = text
                    default: break
                    }
                }
            )
        )
    }
    
    // MARK: - Uploads
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
    
    private func configureUploadHandlers() {
        uploadCertificateRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }
            if case .pick = result {
                self.pickFile? { picked in
                    self.state.certificate = picked
                    self.uploadCertificateRow.selectedDocumentName = picked?.fileName
                    self.reloadRow(withTag: self.uploadCertificateRow.tag)
                }
            }
        }
        
        uploadLogoRow.modelDidUpdate = { [weak self] result in
            guard let self else { return }
            if case .pick = result {
                self.pickFile? { picked in
                    self.state.logo = picked
                    if let data = picked?.fileData, let image = UIImage(data: data) {
                        self.uploadLogoRow.selectedImage = image
                        self.uploadLogoRow.selectedDocumentName = nil
                    } else {
                        self.uploadLogoRow.selectedDocumentName = picked?.fileName
                        self.uploadLogoRow.selectedImage = nil
                    }
                    self.reloadRow(withTag: self.uploadLogoRow.tag)
                }
            }
        }
    }
    
    // MARK: - Continue Button
    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Submit",
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
    
    // MARK: - Reload
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
    // MARK: - Parameter Mapping
    private func makeAssociationParams() -> [String: Any] {
        [
            "name": state.associationName,
            "code": state.code,
            "countryId": state.countryId,
            
            "description": state.associationDescription,
            "members": state.members,
            "foundedIn": state.foundedIn,
            "phoneNumber": state.phoneNumber,
            "emailAddress": state.email,
            "website": state.website,
            "instagram": state.instagram,
            "linkedin": state.linkedin,
            "x": state.xURL,
            "physicalAddress": state.physicalAddress
        ]
    }

    // MARK: - Network Call
    private func registerAssociation() async throws -> AssociationResponse? {
        let params = makeAssociationParams()
        
        return try await associationsService.register(
            association: params,
            logo: state.logo,
            certificate: state.certificate,
            accessToken: state.oauthToken
        )
    }

    // MARK: - Submit
    private func submit() async {
        showLoader()
        defer { hideLoader() }
        
        do {
            let _ = try await registerAssociation()
            gotoConfirm?() // Success
        } catch let NetworkError.server(response) {
            await MainActor.run {
                state.errorMessage = response.message
                showError(state.errorMessage ?? "Unknown error")
            }
        } catch {
            await MainActor.run {
                state.errorMessage = "Something went wrong. Please try again."
                showError(state.errorMessage ?? "Unknown error")
            }
        }
    }
    
    // MARK: - State
    private struct State {
        var associationName: String = ""
        var code: String = ""
        
        var associationDescription: String = ""
        var members: Int = 0
        var foundedIn: Int = 0
        var countryId: Int = 0
        
        var phoneNumber: String = ""
        var phoneCountry: Country?
        var website: String = ""
        var instagram: String = ""
        var linkedin: String = ""
        var xURL: String = ""
        var physicalAddress: String = ""
        var email: String = ""
        
        var logo: PickedFile?
        var certificate: PickedFile?
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var errorMessage: String?
    }
    
    private enum SectionTag: Int { case main = 0 }
    private enum CellTag: Int {
        case header = 1, steps, phone, website, instagram, linkedin, xURL, location, continueButton, certificate, logo, email
    }
}
