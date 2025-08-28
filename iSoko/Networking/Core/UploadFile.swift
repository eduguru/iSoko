//
//  UploadFile.swift
//  NetworkingKit
//
//  Created by Edwin Weru on 15/07/2025.
//

import Foundation

// MARK: — UploadFile
public struct UploadFile {
    public let data: Data
    public let name: String
    public let fileName: String
    public let mimeType: String

    public init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

