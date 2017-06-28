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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            self.photoImageView.file = post["media"] as? PFFile
            self.photoImageView.loadInBackground()
            let author = post["author"] as? PFUser
            self.usernameLabel.text = author?["username"] as? String
            self.captionLabel.text = post["caption"] as? String
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
