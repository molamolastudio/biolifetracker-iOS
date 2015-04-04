//
//  PhotoPickerViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 4/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class PhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var alert = UIAlertController()
    let alertTitle = "Pick Photo From"
    let alertMessage = ""
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupAlertController()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setupAlertController() {
        alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let actionCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { UIAlertAction in self.openCameraPicker()})
            alert.addAction(actionCamera)
        }
        
        let actionGallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { UIAlertAction in self.openGalleryPicker()})
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(actionGallery)
        alert.addAction(actionCancel)
        
        alert.popoverPresentationController!.sourceView = self.view
        alert.popoverPresentationController!.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
    }
    
    func openCameraPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func openGalleryPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
}
