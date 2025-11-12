//
//  LongInputDescriptionFormRow.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit

public final class LongInputDescriptionFormRow: FormRow {
    public let tag: Int
    public var model: LongInputDescriptionModel
    
    public var reuseIdentifier: String { "LongInputDescriptionFormCell" }
    public var rowType: FormRowType { .tableView }
    public var cellTag: String { String(tag) }
    public var nibName: String? { nil }
    public var cellClass: AnyClass? { LongInputDescriptionFormCell.self }

    private var hasValidated = false

    public init(tag: Int, model: LongInputDescriptionModel) {
        self.tag = tag
        self.model = model
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let inputCell = cell as? LongInputDescriptionFormCell else { return cell }
        
        inputCell.configure(with: model)
        inputCell.onTextChanged = { [weak self] newText in
            self?.model.text = newText
            self?.model.onTextChanged?(newText)
            if self?.hasValidated == true {
                self?.validate()
                inputCell.setError(self?.model.validationError)
            }
        }
        
        // Apply card style if needed
        if model.useCardStyle {
            applyCardStyle(to: inputCell)
        }
        
        return inputCell
    }

    private func applyCardStyle(to cell: LongInputDescriptionFormCell) {
        switch model.cardStyle {
        case .border:
            cell.layer.borderWidth = 1
            cell.layer.borderColor = model.cardBorderColor.cgColor
            cell.layer.shadowOpacity = 0
        case .shadow:
            cell.layer.borderWidth = 0
            cell.layer.shadowColor = model.cardShadowColor.cgColor
            cell.layer.shadowOpacity = 0.1
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 4
        case .borderAndShadow:
            cell.layer.borderWidth = 1
            cell.layer.borderColor = model.cardBorderColor.cgColor
            cell.layer.shadowColor = model.cardShadowColor.cgColor
            cell.layer.shadowOpacity = 0.1
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 4
        case .none:
            break
        }
        
        cell.layer.cornerRadius = model.cardCornerRadius
    }

    public func validate() -> Bool {
        hasValidated = true
        model.validationError = model.validate() ? nil : model.validationError
        model.onValidationError?(model.validationError)
        return model.validationError == nil
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 150  // Adjust based on the content or your needs
    }
}
