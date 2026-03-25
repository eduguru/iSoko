//
//  NetworkHeaders.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

// MARK: - Headers
public struct NetworkHeaders {
    
    // MARK: - Header Keys (avoids string duplication bugs)
    public enum Key {
        public static let contentType = "Content-Type"
        public static let accept = "Accept"
        public static let authorization = "Authorization"
        public static let platform = "X-Platform"
        public static let appVersion = "X-App-Version"
        public static let locale = "Accept-Language"
    }
    
    // MARK: - Base
    
    /// Base headers used by all requests
    public static func base() -> [String: String] {
        [
            Key.contentType: "application/json",
            Key.accept: "application/json"
        ]
    }
    
    // MARK: - Builders
    
    /// Adds bearer token
    public static func withAuth(
        _ headers: [String: String] = base(),
        accessToken: String
    ) -> [String: String] {
        var updated = headers
        updated[Key.authorization] = "Bearer \(accessToken)"
        return updated
    }
    
    /// Adds platform info (web / ios / android)
    public static func withPlatform(
        _ headers: [String: String] = base(),
        platform: String = "web"
    ) -> [String: String] {
        var updated = headers
        updated[Key.platform] = platform
        return updated
    }
    
    /// Adds app metadata (future-proofing)
    public static func withAppInfo(
        _ headers: [String: String] = base(),
        version: String? = nil,
        locale: String? = nil
    ) -> [String: String] {
        var updated = headers
        
        if let version {
            updated[Key.appVersion] = version
        }
        
        if let locale {
            updated[Key.locale] = locale
        }
        
        return updated
    }
    
    // MARK: - Presets (Convenience)
    
    /// Standard API request (no auth)
    public static func standard() -> [String: String] {
        base()
    }
    
    /// Authenticated API request
    public static func authenticated(accessToken: String) -> [String: String] {
        withAuth(base(), accessToken: accessToken)
    }
    
    /// Web request (optional auth)
    public static func web(accessToken: String? = nil) -> [String: String] {
        var headers = withPlatform(base(), platform: "web")
        
        if let token = accessToken {
            headers = withAuth(headers, accessToken: token)
        }
        
        return headers
    }
}


//✅ 1. Basic (No Auth)
//let headers = NetworkHeaders.standard()
//
//let target = AnyTarget(
//    baseURL: ApiEnvironment.apiBaseURL,
//    path: "public/products",
//    method: .get,
//    task: .requestPlain,
//    headers: headers,
//    authorizationType: .none
//)
//✅ 2. Authenticated Request
//let headers = NetworkHeaders.authenticated(accessToken: accessToken)
//
//let target = AnyTarget(
//    baseURL: ApiEnvironment.apiBaseURL,
//    path: "bookkeeping/sales",
//    method: .get,
//    task: .requestParameters(parameters: ["page": 1, "count": 20], encoding: URLEncoding.default),
//    headers: headers,
//    authorizationType: .bearer
//)
//✅ 3. Web Request (Optional Auth)
//let headers = NetworkHeaders.web(accessToken: accessToken)
//// OR
//let headers = NetworkHeaders.web()
//
//let target = AnyTarget(
//    baseURL: ApiEnvironment.apiBaseURL,
//    path: "web/dashboard",
//    method: .get,
//    task: .requestPlain,
//    headers: headers,
//    authorizationType: accessToken != nil ? .bearer : .none
//)
//✅ 4. Fully Composed (Advanced Use)
//let headers = NetworkHeaders.withAuth(
//    NetworkHeaders.withPlatform(
//        NetworkHeaders.base(),
//        platform: "ios"
//    ),
//    accessToken: accessToken
//)
//
//👉 Useful when:
//
//You want "ios" instead of "web"
//You’re debugging or experimenting
//✅ 5. With App Info (Version + Locale)
//let headers = NetworkHeaders.withAuth(
//    NetworkHeaders.withAppInfo(
//        NetworkHeaders.withPlatform(platform: "ios"),
//        version: "1.0.0",
//        locale: "en-KE"
//    ),
//    accessToken: accessToken
//)
//✅ 6. Cleanest Pattern Inside Your API
//static func getAllSales(accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
//    
//    let headers = NetworkHeaders.authenticated(accessToken: accessToken)
//    
//    let target = AnyTarget(
//        baseURL: ApiEnvironment.apiBaseURL,
//        path: "bookkeeping/sales",
//        method: .get,
//        task: .requestPlain,
//        headers: headers,
//        authorizationType: .bearer
//    )
//    
//    return UnifiedPagedResponseTarget(target: target)
//}
