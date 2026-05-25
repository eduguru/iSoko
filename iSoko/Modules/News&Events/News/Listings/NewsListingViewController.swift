//
//  NewsListingViewController.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import UIKit
import DesignSystemKit

class NewsListingViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
}
