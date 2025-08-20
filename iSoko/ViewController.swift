//
//  ViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 11/07/2025.
//

import UIKit
import UtilsKit  // Your package
import DesignSystemKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Explicit enum type helps the compiler
        view.backgroundColor = UIColor.app(ColorStyle.warning)
        
        // Or assign first to variable for clarity
        let primaryColor: ColorStyle = .warning
        view.tintColor = UIColor.app(primaryColor)
        
        print("welcome.greetings".localized)
        UITextField().text = "welcome.greetings".localized
    }
}
