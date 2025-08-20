//
//  PDFPreviewViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import UIKit
import PDFKit

public class PDFPreviewViewController: UIViewController {
    
    private let pdfURL: URL
    private let pdfView = PDFView()
    
    public init(pdfURL: URL) {
        self.pdfURL = pdfURL
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        view.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        } else {
            // Show error or dismiss
            dismiss(animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
