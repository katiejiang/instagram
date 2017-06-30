//
//  UpdateProfileViewController.swift
//  Instagram
//
//  Created by Katie Jiang on 6/28/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var changeProfilePicture: UIButton!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    
    let user : PFUser = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make profile pic circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        // Change profile picture
        changeProfilePicture.layer.cornerRadius = 5
        
        // Set default field values
        nameField.text = user["name"] as? String
        usernameField.text = user["username"] as? String
        bioField.text = user["bio"] as? String
        let profilePicture = user["profilePicture"] as? PFFile
        profileImageView.file = profilePicture
        profileImageView.loadInBackground()
    }
    
    @IBAction func onChangeProfilePicture(_ sender: Any) {
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
    
    func onLoadCamera(_ sender: Any) {
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
    
    func onLoadPhotoLibrary(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image != nil {
            profileImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onDone(_ sender: Any) {
        if (usernameField.text != user.username) {
            let query = PFUser.query()!
            query.whereKey("username", equalTo: usernameField.text ?? "")
            query.getFirstObjectInBackground(block: { (potentialUser: PFObject?, error: Error?) in
                if error != nil && potentialUser == nil {
                    self.user["name"] = self.nameField.text
                    self.user["username"] = self.usernameField.text
                    self.user["bio"] = self.bioField.text
                    self.user["profilePicture"] = Post.getPFFileFromImage(image: self.profileImageView.image)
                    self.user.saveInBackground()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Username Taken", message: "Please choose another username.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                        // handle response here.
                        self.usernameField.text = self.user["username"] as? String
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                }
            })
        } else {
            user["name"] = nameField.text
            user["bio"] = bioField.text
            self.user["profilePicture"] = Post.getPFFileFromImage(image: profileImageView.image)
            user.saveInBackground()
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(String(describing: error.localizedDescription))
            } else {
                self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
