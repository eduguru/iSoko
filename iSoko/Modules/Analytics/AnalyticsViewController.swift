//
//  AnalyticsViewController.swift
//  
//
//  Created by Edwin Weru on 02/06/2026.
//


import UIKit
import DesignSystemKit

class AnalyticsViewController: FormViewController, CloseableViewController {
    var goToCreateAction: (() -> Void)?
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "common.analytics.title".localized
        
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
    
    @objc func didTapButton01() {
        goToCreateAction?()
    }
}


