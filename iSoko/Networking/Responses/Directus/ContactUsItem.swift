
import Foundation

// MARK: - Contact Us
struct ContactUsItem: Decodable {
    let id: Int
    let contactTitle: String?
    let emailContact: String?
    let isForMobile: Bool?
    let mobileContact: String?
    let officeLocation: String?
    let website: String?
    let title: String

    private enum CodingKeys: String, CodingKey {
        case id
        case contactTitle = "contact_title"
        case emailContact = "email_contact"
        case isForMobile = "is_for_mobile"
        case mobileContact = "mobile_contact"
        case officeLocation = "office_location"
        case website
        case title
    }
}

struct FeaturedImageItem: Decodable {
    let filenameDisk: String?

    private enum CodingKeys: String, CodingKey {
        case filenameDisk = "filename_disk"
    }

    func getImageUrl(baseUrl: String) -> String? {
        guard let filenameDisk else { return nil }
        return "\(baseUrl)/assets/\(filenameDisk)"
    }
}
