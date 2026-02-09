//
//  UploadResult.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

public enum UploadResult {
    case pick
    case selected(image: UIImage, url: URL)
    case selectedDocument(name: String, url: URL)
}
