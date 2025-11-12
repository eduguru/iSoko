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
    
    
    // ✅ NEW: insertDividers function
    /// Inserts DividerFormRow(s) before first, between cells, and/or after last based on flags.
    /// - Parameters:
    ///   - cells: Original array of FormRows.
    ///   - dividerTagStart: Base tag for divider rows (default 2000).
    ///   - insertBeforeFirst: Insert divider before first cell (default false).
    ///   - insertBetween: Insert divider between cells (default true).
    ///   - insertAfterLast: Insert divider after last cell (default false).
    ///   - dividerFactory: Closure to create DividerFormRow given a tag (default creates standard DividerFormRow).
    /// - Returns: New array of FormRows with dividers inserted.
    public static func insertDividers(
        into cells: [FormRow],
        dividerTagStart: Int = 2000,
        insertBeforeFirst: Bool = false,
        insertBetween: Bool = true,
        insertAfterLast: Bool = false,
        dividerFactory: ((Int) -> DividerFormRow)? = nil
    ) -> [FormRow] {
        guard !cells.isEmpty else { return [] }

        let createDivider = dividerFactory ?? { DividerFormRow(tag: $0) }

        var result: [FormRow] = []
        var dividerTag = dividerTagStart

        if insertBeforeFirst {
            result.append(createDivider(dividerTag))
            dividerTag += 1
        }

        for (index, cell) in cells.enumerated() {
            result.append(cell)

            // Add divider between cells
            if insertBetween && index < cells.count - 1 {
                result.append(createDivider(dividerTag))
                dividerTag += 1
            }
        }

        if insertAfterLast {
            result.append(createDivider(dividerTag))
        }

        return result
    }
}
