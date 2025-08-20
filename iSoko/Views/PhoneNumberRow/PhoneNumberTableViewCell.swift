//
//  PhoneNumberTableViewCell.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import UIKit
import PhoneNumberKit

class PhoneNumberTableViewCell: UITableViewCell {
    
    private var phoneNumberTextField: PhoneNumberTextField!
    private var phoneNumberModel: PhoneNumberModel!
    
    func configure(with textField: PhoneNumberTextField, model: PhoneNumberModel) {
        self.phoneNumberTextField = textField
        self.phoneNumberModel = model
        setupTextField()
        updateTextField()
    }
    
    private func setupTextField() {
        phoneNumberTextField.frame = CGRect(x: 15, y: 10, width: self.contentView.frame.width - 30, height: 40)
        
        // Use model values for customization
        phoneNumberTextField.placeholder = phoneNumberModel.placeholder
        phoneNumberTextField.defaultRegion = phoneNumberModel.defaultRegion
        phoneNumberTextField.tintColor = .white
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.withFlag = phoneNumberModel.withFlag
        phoneNumberTextField.textContentType = .telephoneNumber
        phoneNumberTextField.keyboardType = .phonePad
        
        phoneNumberTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        self.contentView.addSubview(phoneNumberTextField)
    }
    
    private func updateTextField() {
        phoneNumberTextField.text = phoneNumberModel.phoneNumber
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        phoneNumberModel.phoneNumber = textField.text
    }
}
