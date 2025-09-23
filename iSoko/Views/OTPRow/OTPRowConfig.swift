//
//  OTPRowConfig.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//


import UIKit

// MARK: - Config

public struct OTPRowConfig {
    public var numberOfDigits: Int
    public var sentMessage: String?
    public var showResendTimer: Bool
    public var resendDuration: Double
    public var keyboardType: UIKeyboardType

    public var onOTPComplete: ((String) -> Void)?
    public var onResendTapped: (() -> Void)?

    public init(
        numberOfDigits: Int = 6,
        sentMessage: String? = nil,
        showResendTimer: Bool = true,
        resendDuration: Double = 30,
        keyboardType: UIKeyboardType = .numberPad,
        onOTPComplete: ((String) -> Void)? = nil,
        onResendTapped: (() -> Void)? = nil
    ) {
        self.numberOfDigits = numberOfDigits
        self.sentMessage = sentMessage
        self.showResendTimer = showResendTimer
        self.resendDuration = resendDuration
        self.keyboardType = keyboardType
        self.onOTPComplete = onOTPComplete
        self.onResendTapped = onResendTapped
    }
}
