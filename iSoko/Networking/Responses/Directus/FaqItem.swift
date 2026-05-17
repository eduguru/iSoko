
// MARK: - FAQ
struct FaqItem: Decodable {
    let id: Int
    let status: String?
    let title: String?
    let body: String?
    let faqId: String?
    let category: String?

    private enum CodingKeys: String, CodingKey {
        case id, status, title, body
        case faqId = "faq_id"
        case category = "faq_item_category"
    }
}
