//
//  CommonOptionPickerViewController.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit
import DesignSystemKit

class CommonOptionPickerViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Select an option"
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

