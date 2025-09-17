//
//  Helpers.swift
//  
//
//  Created by Edwin Weru on 16/09/2025.
//

import DesignSystemKit

public struct Helpers {
    
    /// Inserts SpacerFormRow(s) before first, between cells, and/or after last based on flags.
    /// - Parameters:
    ///   - cells: Original array of FormRows.
    ///   - spacerTagStart: Base tag for spacer rows (default 1000).
    ///   - insertBeforeFirst: Insert spacer before first cell (default false).
    ///   - insertBetween: Insert spacer between cells (default true).
    ///   - insertAfterLast: Insert spacer after last cell (default false).
    ///   - spacerFactory: Closure to create SpacerFormRow given a tag (default creates standard SpacerFormRow).
    /// - Returns: New array of FormRows with spacers inserted.
    public static func insertSpacers(
        into cells: [FormRow],
        spacerTagStart: Int = 1000,
        insertBeforeFirst: Bool = false,
        insertBetween: Bool = true,
        insertAfterLast: Bool = false,
        spacerFactory: ((Int) -> SpacerFormRow)? = nil
    ) -> [FormRow] {
        guard !cells.isEmpty else { return [] }
        
        let createSpacer = spacerFactory ?? { SpacerFormRow(tag: $0) }
        
        var result: [FormRow] = []
        var spacerTag = spacerTagStart
        
        if insertBeforeFirst {
            result.append(createSpacer(spacerTag))
            spacerTag += 1
        }
        
        for (index, cell) in cells.enumerated() {
            result.append(cell)
            
            // Add spacer between cells
            if insertBetween && index < cells.count - 1 {
                result.append(createSpacer(spacerTag))
                spacerTag += 1
            }
        }
        
        if insertAfterLast {
            result.append(createSpacer(spacerTag))
        }
        
        return result
    }

}
