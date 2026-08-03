import Foundation

struct AssociationEventItem: Decodable {

    let id: Int
    let associationId: Int?

    let eventTitle: String?
    let eventType: String?

    let description: String?

    let startDate: String?
    let startTime: String?
    let endDate: String?
    let endTime: String?

    let location: String?
    let venue: String?
    let physicalAddress: String?

    let organizingInstitution: String?
    let status: String?
    let visibility: String?

    let contactEmail: String?
    let contactNumber: String?

    let registrationLink: String?

    let bannerImage: BannerImage?
    let bannerImage2: BannerImage?
}

extension AssociationEventItem {

    enum CodingKeys: String, CodingKey {
        case id
        case associationId = "association_id"

        case eventTitle = "event_title"
        case eventType = "event_type"

        case description

        case startDate = "start_date"
        case startTime = "start_time"
        case endDate = "end_date"
        case endTime = "end_time"

        case location
        case venue
        case physicalAddress = "physical_address"

        case organizingInstitution = "organizing_institution"
        case status
        case visibility

        case contactEmail = "contact_email"
        case contactNumber = "contact_number"

        case registrationLink = "registration_link"

        case bannerImage = "banner_image"
        case bannerImage2 = "banner_image2"
    }
}

struct BannerImage: Decodable {

    let id: String
    let title: String?

    let filenameDisk: String?
    let filenameDownload: String?

    let type: String?
    let storage: String?

    let width: Int?
    let height: Int?
    let filesize: Int?

    let createdOn: String?
    let modifiedOn: String?
    let uploadedOn: String?

    let uploadedBy: String?

    let description: String?
    let charset: String?
    let duration: Int?
    let embed: String?
    let folder: String?
    let location: String?
    let focalPointX: Int?
    let focalPointY: Int?
}

extension BannerImage {

    enum CodingKeys: String, CodingKey {
        case id
        case title

        case filenameDisk = "filename_disk"
        case filenameDownload = "filename_download"

        case type
        case storage

        case width
        case height
        case filesize

        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case uploadedOn = "uploaded_on"

        case uploadedBy = "uploaded_by"

        case description
        case charset
        case duration
        case embed
        case folder
        case location

        case focalPointX = "focal_point_x"
        case focalPointY = "focal_point_y"
    }
}

extension BannerImage {

    var url: URL? {
        guard let filenameDisk else { return nil }

        return ApiEnvironment.directusBaseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(filenameDisk)
    }

    var urlString: String? {
        url?.absoluteString
    }
}
