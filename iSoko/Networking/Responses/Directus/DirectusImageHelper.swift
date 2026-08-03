

import Foundation

struct DirectusImageHelper {

    static var baseURL: URL {
        ApiEnvironment.directusBaseURL
    }

    static func url(for filename: String) -> URL {
        baseURL.appendingPathComponent("assets")
               .appendingPathComponent(filename)
    }
}
