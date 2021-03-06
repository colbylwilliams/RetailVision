//
//  ProductNavigationController.swift
//  RetailVision
//
//  Created by Colby L Williams on 4/23/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices
import ImagePicker

class ProductNavigationController : UINavigationController, ImagePickerDelegate {
    
    func selectMedia() {
        
        let configuration = Configuration()

        configuration.recordLocation = false
        configuration.managesAudioSession = false
        
        let imagePickerController = ImagePickerController(configuration: configuration)
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }

    
    // MARK: - ImagePickerDelegate
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        addImages(imagePicker, images: images)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

        addImages(imagePicker, images: images)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {

        imagePicker.dismiss(animated: true, completion: nil)
    }

    func addImages(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        (self.topViewController as? ImageCollectionViewController)?.startLoadAnimation()
        
        imagePicker.dismiss(animated: true) {
            ProductManager.shared.addImagesForSelectedProduct(images) { r in
                if let error = r.error {
                    self.showErrorAlert(error)
                } else {
                    r.printResult()
                    DispatchQueue.main.async {
                        (self.topViewController as? ImageCollectionViewController)?.refreshImages()
                    }
                }
            }
        }
    }
}
