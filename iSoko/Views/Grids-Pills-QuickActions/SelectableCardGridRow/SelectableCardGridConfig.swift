//
//  SelectableCardGridConfig.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//


// MARK: - SelectableCardGridConfig
public struct SelectableCardGridConfig {
    public let items: [SelectableCardItemConfig]
    public let allowsMultipleSelection: Bool
    public let selectedIndices: Set<Int>

    public init(
        items: [SelectableCardItemConfig],
        allowsMultipleSelection: Bool = false,
        selectedIndices: Set<Int> = []
    ) {
        self.items = items
        self.allowsMultipleSelection = allowsMultipleSelection
        self.selectedIndices = selectedIndices
    }
}
