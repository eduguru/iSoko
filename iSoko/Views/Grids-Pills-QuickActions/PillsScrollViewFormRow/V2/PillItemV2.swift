//
//  PillItemV2.swift
//  
//
//  Created by Edwin Weru on 17/04/2026.
//

import UIKit
import DesignSystemKit

public enum PillsLayoutMode {
    case scrollable
    case segmentedStretch
}

public enum PillsSelectionMode {
    case single
    case multiple
}

public typealias PillsSelectionHandler = ([PillItem]) -> Void
