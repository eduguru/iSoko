

import Foundation

struct DirectusImageHelper {
    static let baseURL = URL(string: "http://directus.dev.isoko.africa")!

    static func url(for filename: String) -> URL {
        return baseURL.appendingPathComponent("/assets/\(filename)")
    }
}
