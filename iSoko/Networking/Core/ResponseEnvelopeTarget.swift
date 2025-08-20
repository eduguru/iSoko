//
//  ResponseEnvelopeTarget.swift
//  NetworkingKit
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation

public struct BasicResponse: Decodable {
    public let success: Bool
    public let message: String?
}

public struct ObjectResponse<Payload: Decodable>: Decodable {
    public let data: Payload
}

public struct OptionalObjectResponse<Payload: Decodable>: Decodable {
    public let data: Payload?
}

public typealias BasicResponseTarget = ResponseEnvelopeTarget<BasicResponse>
public typealias ValueResponseTarget<Value: Decodable> = ResponseEnvelopeTarget<Value>
public typealias ObjectResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<ObjectResponse<Payload>>
public typealias OptionalObjectResponseTarget<Payload: Decodable> = ResponseEnvelopeTarget<OptionalObjectResponse<Payload>>

public struct ResponseEnvelopeTarget<Response: Decodable> {
    public let target: AnyTarget
    public init(target: AnyTarget) {
        self.target = target
    }
}
