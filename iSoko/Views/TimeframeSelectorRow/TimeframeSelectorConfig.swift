//
//  TimeframeSelectorConfig.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//


public struct TimeframeSelectorConfig {
    public let options: [TimeframeOption]
    public let allowsMultipleSelection: Bool
    public var selectedIndex: Int?

    public init(
        options: [TimeframeOption],
        allowsMultipleSelection: Bool = false,
        selectedIndex: Int? = nil
    ) {
        self.options = options
        self.allowsMultipleSelection = allowsMultipleSelection
        self.selectedIndex = selectedIndex
    }
}
