//
//  StepStripModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit

public struct StepStripModel {
    public var title: String?
    public var totalSteps: Int
    public var currentStep: Int

    // Styling
    public var activeColor: UIColor?
    public var inactiveColor: UIColor?
    public var titleColor: UIColor?

    public init(
        title: String? = nil,
        totalSteps: Int,
        currentStep: Int,
        activeColor: UIColor? = .systemBlue,
        inactiveColor: UIColor? = .systemGray4,
        titleColor: UIColor? = .secondaryLabel
    ) {
        self.title = title
        self.totalSteps = totalSteps
        self.currentStep = currentStep
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.titleColor = titleColor
    }
}
