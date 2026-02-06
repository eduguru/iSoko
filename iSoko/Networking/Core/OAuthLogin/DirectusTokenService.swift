//
//  DirectusTokenService.swift
//  
//
//  Created by Edwin Weru on 05/02/2026.
//

import Foundation
import StorageKit

struct DirectusResponse<T: Decodable>: Decodable {
    let data: [T]
}

struct DirectusAuthResponse: Decodable {
    let data: DirectusAuthToken
}

struct DirectusAuthToken: Decodable {
    let accessToken: String
    let refreshToken: String
    let expires: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expires
    }
}

struct DirectusNewsItem: Decodable {
    let id: Int
    let title: String?
    let body: String?
    let status: String?
    let createdOn: String?
    let newsCategory: NewsCategory?
    let featuredImage: FeaturedImage?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "Title"
        case body = "Body"
        case status
        case createdOn = "created_on"
        case newsCategory = "News_Category"
        case featuredImage = "Featured_Image"
    }
}

struct NewsCategory: Decodable {
    let key: Int?
    let collection: String?
}

struct FeaturedImage: Decodable {
    let id: String
    let filenameDisk: String?

    enum CodingKeys: String, CodingKey {
        case id
        case filenameDisk = "filename_disk"
    }
}

extension FeaturedImage {
    func url(baseURL: URL) -> URL {
        baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(id)
    }
}

struct AssociationNewsItem: Decodable {
    let id: Int
    let associationId: Int?
    let createdOn: String?
    let modifiedOn: String?
    let newsCategory: String?
    let newsContent: String?
    let newsTitle: String?
    let visibility: String?
    let featuredImage: AssociationFeaturedImage?

    enum CodingKeys: String, CodingKey {
        case id
        case associationId = "association_id"
        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case newsCategory = "news_category"
        case newsContent = "news_content"
        case newsTitle = "news_title"
        case visibility
        case featuredImage = "featured_image"
    }
}

struct AssociationFeaturedImage: Decodable {
    let filenameDisk: String?

    enum CodingKeys: String, CodingKey {
        case filenameDisk = "filename_disk"
    }

    func url(baseURL: URL) -> URL? {
        guard let id = filenameDisk else { return nil }
        return baseURL.appendingPathComponent("assets").appendingPathComponent(id)
    }

    func url2(baseURL: URL) -> URL? {
        guard let filename = filenameDisk else { return nil }
        return baseURL
            .appendingPathComponent("assets")
            .appendingPathComponent(filename)
    }
}

final class DirectusTokenService {

    private let baseURL = URL(string: "http://directus.dev.isoko.africa")!
    private var token: DirectusAuthToken?

    init() {
        // load token from storage if exists
        if let saved = AppStorage.directusToken {
            token = DirectusAuthToken(
                accessToken: saved.accessToken,
                refreshToken: saved.refreshToken ?? "",
                expires: saved.expiresIn
            )
        }
    }

    // MARK: - Login

    func login(email: String, password: String) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("/auth/login"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONSerialization.data(
            withJSONObject: ["email": email, "password": password]
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode)
        else {
            throw OAuthError.httpStatus(
                code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                message: String(data: data, encoding: .utf8)
            )
        }

        let decoded = try JSONDecoder()
            .decode(DirectusAuthResponse.self, from: data)

        let token = decoded.data

        // store locally
        self.token = token

        // store in AppStorage
        AppStorage.directusToken = TokenResponse(
            accessToken: token.accessToken,
            tokenType: "",
            expiresIn: token.expires,
            scope: "",
            refreshToken: token.refreshToken
        )
    }

    // MARK: - Refresh

    private func refresh() async throws {
        guard let refresh = token?.refreshToken else {
            throw OAuthError.unauthorized(reason: "Missing refresh token")
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("/auth/refresh"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONSerialization.data(
            withJSONObject: ["refresh_token": refresh]
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode)
        else {
            throw OAuthError.unauthorized(reason: "Refresh failed")
        }

        let decoded = try JSONDecoder()
            .decode(DirectusAuthResponse.self, from: data)

        let token = decoded.data

        // store locally
        self.token = token

        // store in AppStorage
        AppStorage.directusToken = TokenResponse(
            accessToken: token.accessToken,
            tokenType: "",
            expiresIn: token.expires,
            scope: "",
            refreshToken: token.refreshToken
        )
    }

    // MARK: - Authenticated request helper

    private func authorizedRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {

        guard let token else {
            throw OAuthError.unauthorized(reason: "Missing token")
        }

        var req = request
        req.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse else {
            throw OAuthError.emptyResponse
        }

        if http.statusCode == 401 {
            try await refresh()
            return try await authorizedRequest(request)
        }

        guard (200...299).contains(http.statusCode) else {
            throw OAuthError.httpStatus(
                code: http.statusCode,
                message: String(data: data, encoding: .utf8)
            )
        }

        return (data, http)
    }

    // MARK: - Fetch News

    func fetchNews() async throws -> [DirectusNewsItem] {
        let url = baseURL.appendingPathComponent("/items/News")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<DirectusNewsItem>.self, from: data)
            .data
    }

    // MARK: - Fetch Association News

    func fetchAssociationNews(associationId: String) async throws -> [AssociationNewsItem] {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("/items/association_news"),
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(name: "fields", value: "*.*"),
            URLQueryItem(
                name: "filter",
                value: "{\"association_id\":{\"_eq\":\"\(associationId)\"}}"
            )
        ]

        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<AssociationNewsItem>.self, from: data)
            .data
    }
}
