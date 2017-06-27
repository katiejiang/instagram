//
//  PhotoViewController.swift
//  Instagram
//
//  Created by Katie Jiang on 6/27/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loadCamera(_ sender: Any) {
        // Instantiates a UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loadCameraRoll(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController

//        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Do something with the images
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            photoImageView.image = editedImage
        }
        
        
        // Dismiss the UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

}
