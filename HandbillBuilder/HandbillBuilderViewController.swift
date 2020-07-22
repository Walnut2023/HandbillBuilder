//
//  ViewController.swift
//  HandbillBuilder
//
//  Created by Tangos on 2020/7/22.
//  Copyright © 2020 Tangorios. All rights reserved.
//

import UIKit

class HandbillBuilderViewController: UIViewController {
    @IBOutlet weak var handbillTextEntry: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var contactTextView: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerUI()
    }
    
    func customerUI() {
        // Add subtle outline around text views
        bodyTextView.layer.borderColor = UIColor.gray.cgColor
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.cornerRadius = 4.0
        contactTextView.layer.borderColor = UIColor.gray.cgColor
        contactTextView.layer.borderWidth = 1.0
        contactTextView.layer.cornerRadius = 4.0
    }
    
    /// Action
    
    @IBAction func selectImageAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = false
                
                self.present(photoPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.sourceType = .camera
                
                self.present(cameraPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func previewAction(_ sender: Any) {
        let vc = PDFPreviewViewController()
        
        if let title = handbillTextEntry.text, let body = bodyTextView.text,
            let image = imagePreview.image, let contact = contactTextView.text {
            let pdfCreator = PDFCreator(title: title, body: body,
                                        image: image, contact: contact)
            vc.documentData = pdfCreator.createFlyer()
        }
        
        self.navigationController?.show(vc, sender: nil)
    }
    @IBAction func shareAction(_ sender: Any) {
        // 1
        guard
            let title = handbillTextEntry.text,
            let body = bodyTextView.text,
            let image = imagePreview.image,
            let contact = contactTextView.text
            else {
                // 2
                let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
        }
        
        // 3
        let pdfCreator = PDFCreator(title: title, body: body, image: image, contact: contact)
        let pdfData = pdfCreator.createFlyer()
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if
            let _ = handbillTextEntry.text,
            let _ = bodyTextView.text,
            let _ = imagePreview.image,
            let _ = contactTextView.text {
            return true
        }
        
        let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            guard let vc = segue.destination as? PDFPreviewViewController else { return }
            
            if let title = handbillTextEntry.text, let body = bodyTextView.text,
                let image = imagePreview.image, let contact = contactTextView.text {
                let pdfCreator = PDFCreator(title: title, body: body,
                                            image: image, contact: contact)
                vc.documentData = pdfCreator.createFlyer()
            }
        }
    }
}

extension HandbillBuilderViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imagePreview.image = selectedImage
        imagePreview.isHidden = false
        
        dismiss(animated: true, completion: nil)
    }
}

extension HandbillBuilderViewController: UINavigationControllerDelegate {
    // Not used, but necessary for compilation
}


