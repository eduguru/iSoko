//
//  Helpers.swift
//
//
//  Created by Edwin Weru on 16/09/2025.
//

import DesignSystemKit
import NetworkingKit
import UtilsKit

public struct Helpers {
    
    /// Inserts SpacerFormRow(s) before first, between cells, and/or after last based on flags.
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
    
    /// Inserts DividerFormRow(s) before first, between cells, and/or after last based on flags.
    
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


public extension Helpers {
    static func mapPickedFileToUploadFile(
        _ file: PickedFile?,
        name: String = "file"
    ) -> UploadFile? {
        
        guard let file,
              let data = file.fileData else { return nil }
        
        return UploadFile(
            data: data,
            name: name,
            fileName: file.fileName,
            mimeType: mimeType(for: file.fileExtension)
        )
    }
    
    static func mapPickedFile2UploadFile(_ files: [PickedFile]?) -> [UploadFile] {
        guard let files else { return [] }
        
        return files.compactMap { file in
            guard let data = file.fileData else { return nil }
            
            return UploadFile(
                data: data,
                name: "file",
                fileName: file.fileName,
                mimeType: mimeType(for: file.fileExtension)
            )
        }
    }
    
    static func mapPickedFile2UploadFile(
        _ files: [PickedFile]?,
        name: String = "file"
    ) -> [UploadFile] {
        guard let files else { return [] }
        
        return files.compactMap { file in
            guard let data = file.fileData else { return nil }
            
            return UploadFile(
                data: data,
                name: name,
                fileName: file.fileName,
                mimeType: mimeType(for: file.fileExtension)
            )
        }
    }
    
    static func mimeType(for ext: String) -> String {
        switch ext.lowercased() {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "pdf":
            return "application/pdf"
        default:
            return "application/octet-stream"
        }
    }
}
