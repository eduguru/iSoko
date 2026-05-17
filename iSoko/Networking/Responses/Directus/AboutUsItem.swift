
// MARK: - About Us
struct AboutUsItem: Decodable {
    let id: Int
    let quote: String?
    let body: String?
    let title: String?
    let featuredTitle: String?
    let featuredImage: FeaturedImageItem?
    let backgroundImage: FeaturedImageItem?

    private enum CodingKeys: String, CodingKey {
        case id, quote
        case body = "about_content"
        case title = "page_title"
        case featuredTitle = "featured_title"
        case featuredImage = "featured_image"
        case backgroundImage = "header_background_image"
    }
}

