//
//  AssociationsApi.swift
//  
//
//  Created by Edwin Weru on 03/02/2026.
//

import Moya
import Foundation
import NetworkingKit
import UtilsKit

public struct AssociationsApi {
    
    //MARK: -
    public static func getAllAssociations(page: Int, count: Int, accessToken: String) -> NewPagedResponseTarget<[AssociationResponse]> {

        let parameters: [String: Any] = ["page": page, "size": count]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        var locationUrl: URL = { URL(string: "https://api.dev.isoko.africa/" )! }()
        
        let target = AnyTarget(
            baseURL: locationUrl,
            path: "v1/associations",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers
        )

        return NewPagedResponseTarget(target: target)
    }
    
    
    public static func getAllPendingAssociations(page: Int, count: Int, accessToken: String) -> NewPagedResponseTarget<[AssociationResponse]> {

        let parameters: [String: Any] = ["page": page, "size": count, "status": "Pending"]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let locationUrl: URL = { URL(string: "https://api.dev.isoko.africa/" )! }()
        
        let target = AnyTarget(
            baseURL: locationUrl,
            path: "v1/users/7/associations",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers
        )

        return NewPagedResponseTarget(target: target)
    }
    
    public static func getApprovedssociations(page: Int, count: Int, accessToken: String) -> NewPagedResponseTarget<[AssociationResponse]> {

        let parameters: [String: Any] = ["page": page, "size": count, "status": "Approved"]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let locationUrl: URL = { URL(string: "https://api.dev.isoko.africa/" )! }()
        
        let target = AnyTarget(
            baseURL: locationUrl,
            path: "v1/users/7/associations",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers
        )

        return NewPagedResponseTarget(target: target)
    }
    
    static func register(
        association: [String: Any],
        logo: PickedFile?,
        certificate: PickedFile?,
        accessToken: String
    ) -> ValueResponseTarget<AssociationResponse> {

        let associationJSON = try? JSONSerialization.data(withJSONObject: association)
        
        let headers: [String: String] = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]

        var files: [UploadFile] = []

        if let logo,
           let data = logo.fileData,
           !data.isEmpty {
            files.append(
                UploadFile(
                    data: data,
                    name: "logo",
                    fileName: logo.fileName,
                    mimeType: Helpers.mimeType(for: logo.fileExtension)
                )
            )
        }

        if let certificate,
           let data = certificate.fileData,
           !data.isEmpty {
            files.append(
                UploadFile(
                    data: data,
                    name: "certificate",
                    fileName: certificate.fileName,
                    mimeType: Helpers.mimeType(for: certificate.fileExtension)
                )
            )
        }

        let target = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/associations",
            method: .post,
            jsonPartName: "association",
            jsonData: associationJSON,
            files: files,
            headers: headers,
            requiresAuth: false
        )

        return ValueResponseTarget(target: target.asAnyTarget())
    }

    
    static func update(associationId: Int, _ request: [String: Any], accessToken: String) -> ValueResponseTarget<AssociationResponse> {
        let userDict: [String: Any] = request
        let userJSON = try? JSONSerialization.data(withJSONObject: userDict)

        let t = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/associations/\(associationId)",
            jsonPartName: "uslogoer",
            jsonData: userJSON,
            files: [],
            requiresAuth: false
        )

        return ValueResponseTarget(target: t.asAnyTarget())
    }
    
    static func review(associationId: Int, _ request: [String: Any], accessToken: String) -> ValueResponseTarget<AssociationResponse> {
        let userDict: [String: Any] = request
        let userJSON = try? JSONSerialization.data(withJSONObject: userDict)

        let t = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/associations/\(associationId)",
            jsonPartName: "uslogoer",
            jsonData: userJSON,
            files: [],
            requiresAuth: false
        )

        return ValueResponseTarget(target: t.asAnyTarget())
    }
    
    public static func getAssociationById(associationId: Int, accessToken: String) -> ValueResponseTarget<AssociationResponse> {

        let parameters: [String: Any] = ["associationId": associationId]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        var locationUrl: URL = { URL(string: "https://api.dev.isoko.africa/" )! }()
        
        let target = AnyTarget(
            baseURL: locationUrl,
            path: "v1/associations/\(associationId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            requiresAuth: false
        )

        return ValueResponseTarget(target: target)
    }
}

//MARK: - we get members here -
public extension AssociationsApi {
    //MARK: -
    public static func getAllAssociationMembers(associationId: Int, page: Int, count: Int, accessToken: String) -> NewPagedResponseTarget<[AssociationMemberResponse]> {

        let parameters: [String: Any] = ["page": page, "size": count]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        var locationUrl: URL = { URL(string: "https://api.dev.isoko.africa/" )! }()
        
        let target = AnyTarget(
            baseURL: locationUrl,
            path: "v1/associations/\(associationId)/members",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            requiresAuth: false
        )

        return NewPagedResponseTarget(target: target)
    }
    
    static func addMember(associationId: Int, _ request: [String: Any], accessToken: String) -> ValueResponseTarget<AssociationMemberResponse> {
        let userDict: [String: Any] = request
        let userJSON = try? JSONSerialization.data(withJSONObject: userDict)

        let t = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/associations/\(associationId)/members",
            jsonPartName: "uslogoer",
            jsonData: userJSON,
            files: [],
            requiresAuth: false
        )

        return ValueResponseTarget(target: t.asAnyTarget())
    }
    
    static func updateMember(memberId: Int, _ request: [String: Any], accessToken: String) -> ValueResponseTarget<AssociationMemberResponse> {
        let userDict: [String: Any] = request
        let userJSON = try? JSONSerialization.data(withJSONObject: userDict)

        let t = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/members/\(memberId)",
            jsonPartName: "uslogoer",
            jsonData: userJSON,
            files: [],
            requiresAuth: false
        )

        return ValueResponseTarget(target: t.asAnyTarget())
    }
    
    public static func getAssociationMemberById(memberId: Int, accessToken: String) -> ValueResponseTarget<AssociationMemberResponse> {

        let parameters: [String: Any] = ["associationId": memberId]
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        var locationUrl: URL = { URL(string: "https://api.dev.isoko.africa/" )! }()
        
        let target = AnyTarget(
            baseURL: locationUrl,
            path: "v1/members/\(memberId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            requiresAuth: false
        )

        return ValueResponseTarget(target: target)
    }
}
