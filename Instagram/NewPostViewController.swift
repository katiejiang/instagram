//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Katie Jiang on 6/27/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image: UIImage?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionField.isHidden = true
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSelectImage(_ sender: Any) {
        let selectSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.onLoadCamera(sender)
        }
        selectSourceAlert.addAction(cameraAction)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.onLoadPhotoLibrary(sender)
        }
        selectSourceAlert.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        selectSourceAlert.addAction(cancelAction)
        present(selectSourceAlert, animated: true)
    }
    
    @IBAction func onLoadCamera(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            onLoadPhotoLibrary(sender)
        } else {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLoadPhotoLibrary(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        Post.postUserImage(image: photoImageView.image, withCaption: captionField.text) { (success: Bool, error: Error?) in
            if success {
                print("successfully posted!")
            } else if let error = error {
                print(String(describing: error.localizedDescription))
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image != nil {
            photoImageView.image = image
            captionField.isHidden = false
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
