//
//  PDFPreviewViewController.swift
//  HandbillBuilder
//
//  Created by Tangos on 2020/7/22.
//  Copyright © 2020 Tangorios. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
  public var documentData: Data?
  @IBOutlet weak var pdfView: PDFView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let data = documentData {
      pdfView.document = PDFDocument(data: data)
      pdfView.autoScales = true
    }
  }
}
