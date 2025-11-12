//
//  LongDescriptionFormCell.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit


final class LongInputDescriptionFormCell: UITableViewCell, UITextViewDelegate {

    // UI Elements
    private var textView: UITextView!
    private var prefixLabel: UILabel!
    private var errorLabel: UILabel?
    
    var onTextChanged: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialize UI elements
        textView = UITextView()
        prefixLabel = UILabel()
        errorLabel = UILabel()
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        // Setup the textView properties
        textView.delegate = self // Set the delegate here
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        
        // Add the UI elements to the content view
        contentView.addSubview(textView)
        contentView.addSubview(prefixLabel)
        contentView.addSubview(errorLabel!)
        
        // Set constraints for the UI elements (you can adjust this based on your layout system)
        prefixLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            prefixLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            prefixLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            prefixLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            textView.topAnchor.constraint(equalTo: prefixLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 100), // Adjust height as needed
            
            errorLabel!.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            errorLabel!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            errorLabel!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            errorLabel!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        errorLabel?.textColor = .red
        errorLabel?.font = .systemFont(ofSize: 12)
        errorLabel?.numberOfLines = 0
    }

    func configure(with model: LongInputDescriptionModel) {
        // Set text view initial text
        textView.text = model.text
        
        // Set prefix label
        if let prefix = model.titleText {
            prefixLabel.text = prefix
        }
        
        // Set read-only status
        textView.isEditable = !model.config.isReadOnly
        
        // Set scrolling behavior
        textView.isScrollEnabled = model.config.isScrollable
        
        // Update error state
        if let errorMessage = model.validationError {
            errorLabel?.text = errorMessage
        } else {
            errorLabel?.text = ""
        }
        
        // Handle accessory image if needed (like a password toggle)
        if let accessory = model.config.accessoryImage {
            // Add accessory image to the right of the textView
        }
    }
    
    func setError(_ errorMessage: String?) {
       if let error = errorMessage {
           errorLabel?.text = error
       } else {
           errorLabel?.text = ""
       }
   }

    // MARK: - UITextViewDelegate Methods

    func textViewDidChange(_ textView: UITextView) {
        // Notify about text change
        onTextChanged?(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        // Handle start of editing if needed
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Handle end of editing if needed
    }
    
    // You can implement more delegate methods if necessary.

}
