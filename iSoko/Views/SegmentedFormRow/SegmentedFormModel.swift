//
//  SegmentedFormModel.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public struct SegmentedFormModel {
    var title: String?
    var segments: [String]
    var selectedIndex: Int
    var tag: Int

    // Styling
    var tintColor: UIColor?
    var selectedSegmentTintColor: UIColor?
    var backgroundColor: UIColor?
    var titleTextColor: UIColor?
    var segmentTextColor: UIColor?
    var selectedSegmentTextColor: UIColor?

    // New: Callback
    var onSelectionChanged: ((Int) -> Void)?

    public init(
        title: String?,
        segments: [String],
        selectedIndex: Int,
        tag: Int,
        tintColor: UIColor? = nil,
        selectedSegmentTintColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        titleTextColor: UIColor? = nil,
        segmentTextColor: UIColor? = nil,
        selectedSegmentTextColor: UIColor? = nil,
        onSelectionChanged: ((Int) -> Void)? = nil
    ) {
        self.title = title
        self.segments = segments
        self.selectedIndex = selectedIndex
        self.tag = tag
        self.tintColor = tintColor
        self.selectedSegmentTintColor = selectedSegmentTintColor
        self.backgroundColor = backgroundColor
        self.titleTextColor = titleTextColor
        self.segmentTextColor = segmentTextColor
        self.selectedSegmentTextColor = selectedSegmentTextColor
        self.onSelectionChanged = onSelectionChanged
    }
}
