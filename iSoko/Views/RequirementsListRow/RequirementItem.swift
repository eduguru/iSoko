//
//  RequirementItem.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

public struct RequirementItem {
    public var title: String
    public var isSatisfied: Bool

    public init(title: String, isSatisfied: Bool) {
        self.title = title
        self.isSatisfied = isSatisfied
    }
}
