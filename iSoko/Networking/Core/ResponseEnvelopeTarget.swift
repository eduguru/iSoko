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

// Upload-specific
public typealias BasicUploadResponseTarget = ResponseEnvelopeTarget<BasicResponse, UploadTarget>
public typealias ValueUploadResponseTarget<Value: Decodable> = ResponseEnvelopeTarget<Value, UploadTarget>
