//
//  OTPFormViewController.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit
import DesignSystemKit

final class OTPFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = OTPFormViewModel()
        self.title = "OTP Verification"
    }
}
