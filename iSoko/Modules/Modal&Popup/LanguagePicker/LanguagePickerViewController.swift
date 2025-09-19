//
//  LanguagePickerViewController.swift
//  
//
//  Created by Edwin Weru on 18/09/2025.
//

import UIKit
import DesignSystemKit

class LanguagePickerViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Select Language"
        applyCloseButtonStyling(action: #selector(close), image: "backArrow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction()
    }
    
    deinit {
        closeAction()
    }
}

