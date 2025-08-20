//
//  PhoneNumberRow.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import UIKit
import PhoneNumberKit
import DesignSystemKit

public class PhoneNumberRow: NSObject, FormRow {
    
    public var tag: Int
    public var cellTag: String { return String(tag) }
    public var rowType: FormRowType = .tableView
    public var nibName: String? = nil
    
    public let reuseIdentifier: String = String(describing: PhoneNumberTableViewCell.self)
    public var cellClass: AnyClass? { PhoneNumberTableViewCell.self }
    
    private var phoneNumberModel: PhoneNumberModel
    private var phoneNumberTextField: PhoneNumberTextField
    
    // Initializer that accepts a model
    public init(tag: Int, model: PhoneNumberModel) {
        self.tag = tag
        self.phoneNumberModel = model
        self.phoneNumberTextField = PhoneNumberTextField()
        super.init()
    }
    
    // Configure the cell for TableView
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        if let phoneCell = cell as? PhoneNumberTableViewCell {
            phoneCell.configure(with: phoneNumberTextField, model: phoneNumberModel)
        }
        return cell
    }
    
    // Configure the cell for CollectionView (if needed)
    public func configure(_ cell: UICollectionViewCell, indexPath: IndexPath, sender: FormViewController?) -> UICollectionViewCell {
        return cell
    }
    
    // Validate the phone number using the model's method
    public func validate() -> Bool {
        phoneNumberModel.validatePhoneNumber()
        return phoneNumberModel.isValid
    }
    
    // Validate with an error (to show an error message)
    public func validateWithError() -> Bool {
        phoneNumberModel.validatePhoneNumber()
        return phoneNumberModel.isValid
    }
    
    // Reset the field (clear the phone number)
    public func reset() {
        phoneNumberModel.reset()
        phoneNumberTextField.text = ""
    }
    
    // Determine the visibility of the field
    public func fieldVisibility() -> Bool {
        return true
    }
    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
