//
//  BookKeepingExpensesDetailsViewController.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit
import DesignSystemKit

class BookKeepingExpensesDetailsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Expense Details"
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
