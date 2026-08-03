
struct EventItem: Decodable {

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
    let physicalAddress: PhysicalAddress?

    let contactEmail: String?
    let contactNumber: String?

    let registrationLink: String?
    let bannerImage: String?
}

extension EventItem {

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

        case contactEmail = "contact_email"
        case contactNumber = "contact_number"

        case registrationLink = "registration_link"
        case bannerImage = "banner_image"
    }
}

struct PhysicalAddress: Decodable {
    let type: String?
    let coordinates: [Double]?
}
