//
//  PostDetailsViewController.swift
//  Instagram
//
//  Created by Katie Jiang on 6/29/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var photoImageView: PFImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var post: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update info
        self.photoImageView.file = post["media"] as? PFFile
        self.photoImageView.loadInBackground()
        let author = post["author"] as? PFUser
        self.usernameButton.setTitle(author?["username"] as? String, for: UIControlState.normal)
        self.captionLabel.text = post["caption"] as? String
        self.profileImageView.file = author?["profilePicture"] as? PFFile
        self.profileImageView.loadInBackground()
        let likes = post["likesCount"] as! Int
        self.likesLabel.text = "\(String(describing: likes)) likes"
        let date = post.createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        timestampLabel.text = dateFormatter.string(from: date!)
        
        if author != PFUser.current() {
            deleteButton.isHidden = true
        }
        
        // Make profile pic circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func onPhotoOptions(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.post.deleteInBackground(block: { (success: Bool, error: Error?) in
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
            self.activityIndicator.startAnimating()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.user = post["author"] as! PFUser
    }

}
