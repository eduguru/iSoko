//
//  CountryPickerViewController.swift
//  
//
//  Created by Edwin Weru on 17/09/2025.
//

import UIKit
import DesignSystemKit

class CountryPickerViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // title = "Select Country"
        applyCloseButtonStyling(action: #selector(close), image: "backArrow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
}

