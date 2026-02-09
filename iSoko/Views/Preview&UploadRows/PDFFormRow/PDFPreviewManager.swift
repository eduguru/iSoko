//
//  PDFPreviewManager.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import UIKit
import QuickLook

//let manager = PDFPreviewManager()
//manager.previewItem = PDFItem(url: someURL)
//manager.present(from: viewController)

//let termsURL = URL(string: "https://example.com/privacy.pdf")!
//let pdfRow = PDFFormRow(tag: 999, title: "Privacy Policy", pdfURL: termsURL)
//
//sections = [
//    FormSection(cells: [pdfRow])
//]

final class PDFPreviewManager: NSObject, QLPreviewControllerDelegate {
    private weak var presentingController: UIViewController?
    private var previewItem: PDFItem?
    
    init(presentingController: UIViewController) {
        self.presentingController = presentingController
    }
    
    func previewPDF(title: String, url: URL) {
        if url.isFileURL {
            present(fileURL: url, title: title)
        } else {
            downloadAndCache(url: url) { [weak self] localURL in
                guard let self, let localURL else {
                    self?.presentError("Failed to load PDF.")
                    return
                }
                self.present(fileURL: localURL, title: title)
            }
        }
    }
    
    private func downloadAndCache(url: URL, completion: @escaping (URL?) -> Void) {
        let fileName = url.lastPathComponent
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("CachedPDFs/\(fileName)")
        
        // If already cached
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            return completion(destinationURL)
        }

        // Create directory if needed
        try? FileManager.default.createDirectory(
            at: destinationURL.deletingLastPathComponent(),
            withIntermediateDirectories: true,
            attributes: nil
        )

        // Download
        URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            do {
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                DispatchQueue.main.async { completion(destinationURL) }
            } catch {
                print("❌ Failed to move downloaded PDF:", error)
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }

    private func present(fileURL: URL, title: String) {
        let item = PDFItem(url: fileURL, title: title)
        self.previewItem = item
        
        let qlController = QLPreviewController()
        qlController.dataSource = self
        qlController.delegate = self
        
        presentingController?.present(qlController, animated: true)
    }

    private func presentError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        presentingController?.present(alert, animated: true)
    }
}

// MARK: - QLPreviewControllerDataSource
extension PDFPreviewManager: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        print("PDF preview dismissed")
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let item = previewItem else {
            fatalError("previewItem was nil. Ensure it's set before presenting QLPreviewController.")
        }
        return item
    }

}

