//
//  PostCell.swift
//  Instagram
//
//  Created by Katie Jiang on 6/28/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell {
    
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var photoImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            self.photoImageView.file = post["media"] as? PFFile
            self.photoImageView.loadInBackground()
            let author = post["author"] as? PFUser
            self.usernameButton.setTitle(author?["username"] as? String, for: UIControlState.normal)
            self.captionLabel.text = post["caption"] as? String
            self.profileImageView.file = author?["profilePicture"] as? PFFile
            self.profileImageView.loadInBackground()
            let likes = post["likesCount"] as! Int
            self.likesLabel.text = likes > 0 ? "\(String(describing: likes)) likes" : ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        // Make profile pic circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
