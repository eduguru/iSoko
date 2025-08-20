//
//  SearchFormModel.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public enum IconPlacement {
    case left
    case right
    case inside
    case outside
}

public struct SearchFormModel {
    public var placeholder: String
    public var attributedPlaceholder: NSAttributedString?
    
    public var text: String
    public var keyboardType: UIKeyboardType

    public var searchIcon: UIImage?
    public var searchIconPlacement: IconPlacement
    public var filterIcon: UIImage?
    public var filterIconPlacement: IconPlacement

    public var didTapSearchIcon: (() -> Void)?
    public var didTapFilterIcon: (() -> Void)?
    public var didStartEditing: ((String) -> Void)?
    public var didEndEditing: ((String) -> Void)?
    public var onTextChanged: ((String) -> Void)?

    public init(
        placeholder: String = "Search...",
        attributedPlaceholder: NSAttributedString? = nil,
        text: String = "",
        keyboardType: UIKeyboardType = .default,
        searchIcon: UIImage? = UIImage(systemName: "magnifyingglass"),
        searchIconPlacement: IconPlacement = .left,
        filterIcon: UIImage? = nil,
        filterIconPlacement: IconPlacement = .inside,
        didTapSearchIcon: (() -> Void)? = nil,
        didTapFilterIcon: (() -> Void)? = nil,
        didStartEditing: ((String) -> Void)? = nil,
        didEndEditing: ((String) -> Void)? = nil,
        onTextChanged: ((String) -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.attributedPlaceholder = attributedPlaceholder
        self.text = text
        self.keyboardType = keyboardType
        self.searchIcon = searchIcon
        self.searchIconPlacement = searchIconPlacement
        self.filterIcon = filterIcon
        self.filterIconPlacement = filterIconPlacement
        self.didTapSearchIcon = didTapSearchIcon
        self.didTapFilterIcon = didTapFilterIcon
        self.didStartEditing = didStartEditing
        self.didEndEditing = didEndEditing
        self.onTextChanged = onTextChanged
    }
}
