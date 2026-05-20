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

final class DirectusTokenService {

    private let baseURL = URL(string: "https://directus.dev.isoko.africa")!
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

        var components = URLComponents(
            url: baseURL.appendingPathComponent("/items/News"),
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = [
            URLQueryItem(name: "fields", value: "*.*"),
            URLQueryItem(name: "sort", value: "-created_on")
        ]

        guard let url = components?.url else {
            throw OAuthError.invalidAuthURL
        }

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
    
    // MARK: - Fetch Home Banners

    func fetchHomeBanners() async throws -> [DirectusHomeBannerItem] {
        var components = URLComponents(url: baseURL.appendingPathComponent("/items/Hero"), resolvingAgainstBaseURL: false)

        components?.queryItems = [
            URLQueryItem(name: "fields", value: "id,btn_text,btn_url,status,title,image_link.filename_disk"),
            URLQueryItem(name: "filter", value: "{\"status\":{\"_eq\":\"published\"}}")
        ]

        guard let url = components?.url else {
            throw OAuthError.invalidAuthURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Use the authorized request method with the token
        let (data, _) = try await authorizedRequest(request)

        return try JSONDecoder().decode(DirectusResponse<DirectusHomeBannerItem>.self, from: data).data
    }
}


// MARK: - Settings API
extension DirectusTokenService {

    func fetchContactUs() async throws -> [ContactUsItem] {
        var request = URLRequest(url: baseURL.appendingPathComponent("/items/Contact_us"))
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<ContactUsItem>.self, from: data)
            .data
    }

    func fetchAboutUs() async throws -> [AboutUsItem] {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("/items/About_us"),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [
            URLQueryItem(name: "fields", value: "quote,about_content,page_title,featured_title,featured_image.filename_disk,header_background_image.filename_disk")
        ]

        guard let url = components?.url else {
            throw OAuthError.invalidAuthURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<AboutUsItem>.self, from: data)
            .data
    }

    func fetchFAQs() async throws -> [FaqItem] {
        var request = URLRequest(url: baseURL.appendingPathComponent("/items/FAQ_items"))
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<FaqItem>.self, from: data)
            .data
    }

    func fetchTermsAndConditions() async throws -> [TermsAndConditionsItem] {
        var request = URLRequest(url: baseURL.appendingPathComponent("/items/Terms_and_conditions"))
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<TermsAndConditionsItem>.self, from: data)
            .data
    }

    func fetchPrivacyPolicy() async throws -> [PrivacyPolicyItem] {
        var request = URLRequest(url: baseURL.appendingPathComponent("/items/Privacy_Policy"))
        request.httpMethod = "GET"

        let (data, _) = try await authorizedRequest(request)
        return try JSONDecoder()
            .decode(DirectusResponse<PrivacyPolicyItem>.self, from: data)
            .data
    }
}
