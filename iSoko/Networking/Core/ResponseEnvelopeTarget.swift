//
//  ResponseEnvelopeTarget.swift
//  NetworkingKit
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation
import Moya
import NetworkingKit

// MARK: - Response Models

public enum UnifiedPagedEnvelope<Payload: Decodable>: Decodable {
    case old(data: Payload)
    case new(
        data: Payload,
        page: NewPageInfo,
        query: [String: [String]]?
    )
    
    public struct NewPageInfo: Decodable {
        public let number: Int
        public let size: Int
        public let totalPages: Int
        public let totalElements: Int
    }
    
    private enum CodingKeys: String, CodingKey {
        case data
        case page
        case query
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let page = try? container.decode(NewPageInfo.self, forKey: .page) {
            let data = try container.decode(Payload.self, forKey: .data)
            let query = try? container.decode([String: [String]].self, forKey: .query)
            self = .new(data: data, page: page, query: query)
            return
        }
        
        let data = try container.decode(Payload.self, forKey: .data)
        self = .old(data: data)
    }
}


public struct PagedResult<Data> {
    public let data: Data
    public let page: Int?
    public let size: Int?
    public let totalPages: Int?
    public let totalElements: Int?
}

public struct BasicResponse: Decodable {
    public let data: String?
    public let status: Int
    public let message: String?
    public let errors: [ErrorsObject]?
    
    public struct ErrorsObject: Decodable {
        public let field: String?
        public let message: String?
    }
}

public struct PagedResponse<Payload: Decodable>: Decodable {
    public let status: Int
    public let message: String?
    public let errors: [BasicResponse.ErrorsObject]?
    public let data: Payload
    public let total: Int
}

public struct PagedOptionalResponse<Payload: Decodable>: Decodable {
    public let status: Int
    public let message: String?
    public let errors: [BasicResponse.ErrorsObject]?
    public let data: Payload?
    public let total: Int
}

public struct NewPagedResponse<Payload: Decodable>: Decodable {
    public struct PageInfo: Decodable {
        public let number: Int
        public let size: Int
        public let totalPages: Int
        public let totalElements: Int
    }
    
    public let data: Payload
    public let query: [String: [String]]? // ✅ correct
    public let page: PageInfo
}

public extension NewPagedResponse {
    var pageNumber: Int? {
        query?["page"]?.first.flatMap(Int.init)
    }
    
    var pageSize: Int? {
        query?["size"]?.first.flatMap(Int.init)
    }
}


public struct ObjectResponse<Payload: Decodable>: Decodable {
    public let data: Payload
}

public struct OptionalObjectResponse<Payload: Decodable>: Decodable {
    public let data: Payload?
}

// MARK: - Generic Response Envelope
public struct ResponseEnvelopeTarget<Response: Decodable, T: TargetType> {
    public let target: T
    public init(target: T) {
        self.target = target
    }
}

// MARK: - Convenience Typealiases

public typealias BasicResponseTarget = ResponseEnvelopeTarget<BasicResponse, AnyTarget>
public typealias ValueResponseTarget<Value: Decodable> = ResponseEnvelopeTarget<Value, AnyTarget>
public typealias ObjectResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<ObjectResponse<Payload>, AnyTarget>
public typealias OptionalObjectResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<OptionalObjectResponse<Payload>, AnyTarget>

public typealias PagedResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<PagedResponse<Payload>, AnyTarget>
public typealias PagedOptionalResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<PagedOptionalResponse<Payload>, AnyTarget>
public typealias NewPagedResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<NewPagedResponse<Payload>, AnyTarget>


// Upload-specific
public typealias BasicUploadResponseTarget = ResponseEnvelopeTarget<BasicResponse, UploadTarget>
public typealias ValueUploadResponseTarget<Value: Decodable> = ResponseEnvelopeTarget<Value, UploadTarget>

public typealias UnifiedPagedResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<UnifiedPagedEnvelope<Payload>, AnyTarget>
