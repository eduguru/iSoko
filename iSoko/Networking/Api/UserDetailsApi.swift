//
//  UserDetailsApi.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import Foundation
import Alamofire
import Moya
import NetworkingKit

public struct UserDetailsApi {
    
    //MARK: - get user details
    public static func getUserDetails(accessToken: String) -> OptionalObjectResponseTarget<UserDetailsResponse> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [:]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/auth-details",
            method: .get,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: t)
    }
    
    public static func getTraderVerificationDocuments(accessToken: String) -> OptionalObjectResponseTarget<[TraderVerificationDocResponse]> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [:]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/verification-document/current-user",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: t)
    }
    
    //MARK: - update user details
    public static func updateUserDetails(accessToken: String, with dto: UserDetailsRequestDto) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = dto.asDictionary
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/update-profile/individual",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    
    public static func updateOrganisationDetails(accessToken: String, with dto: OrganisationDetailsRequestDto) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = dto.asDictionary
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/update-profile/organization",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    
    public static func updateUserEmail(email: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/contact-update/email",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    
    public static func updateUserPhone(phone: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "phoneNumber": phone
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/contact-update/phone",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func updateUserProfileImage(image: Data, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "image": image
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/update-profile-image",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
}
