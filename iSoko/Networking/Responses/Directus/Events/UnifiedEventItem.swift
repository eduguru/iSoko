import Foundation

struct UnifiedEventItem {
    let id: Int
    let eventTitle: String?
    let eventType: String?
    let description: String?

    let startDate: String?
    let startTime: String?
    let endDate: String?
    let endTime: String?

    let location: String?
    let venue: String?

    let contactEmail: String?
    let contactNumber: String?
    let registrationLink: String?

    let bannerImageURL: URL?
    let bannerImageURL2: URL?

    let organizingInstitution: String?
    let status: String?
    let source: EventSource

    enum EventSource {
        case publicEvent
        case associationEvent
    }
}

// MARK: - Mappers

extension EventItem {
    func toUnified() -> UnifiedEventItem {
        UnifiedEventItem(
            id: id,
            eventTitle: eventTitle,
            eventType: eventType,
            description: description,
            startDate: startDate,
            startTime: startTime,
            endDate: endDate,
            endTime: endTime,
            location: location,
            venue: venue,
            contactEmail: contactEmail,
            contactNumber: contactNumber,
            registrationLink: registrationLink,
            bannerImageURL: bannerImage.flatMap { URL(string: $0) },
            bannerImageURL2: nil,
            organizingInstitution: nil,
            status: nil,
            source: .publicEvent
        )
    }
}

extension AssociationEventItem {
    func toUnified() -> UnifiedEventItem {
        UnifiedEventItem(
            id: id,
            eventTitle: eventTitle,
            eventType: eventType,
            description: description,
            startDate: startDate,
            startTime: startTime,
            endDate: endDate,
            endTime: endTime,
            location: location,
            venue: venue,
            contactEmail: contactEmail,
            contactNumber: contactNumber,
            registrationLink: registrationLink,
            bannerImageURL: bannerImage?.url,
            bannerImageURL2: bannerImage2?.url,
            organizingInstitution: organizingInstitution,
            status: status,
            source: .associationEvent
        )
    }
}
