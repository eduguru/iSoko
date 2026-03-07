//
//  TimeframeOption.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//


// MARK: - Model
public struct TimeframeOption {
    public let title: String
    public let onTap: (() -> Void)?

    public init(title: String, onTap: (() -> Void)? = nil) {
        self.title = title
        self.onTap = onTap
    }
}
