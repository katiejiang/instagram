//
//  PhotoCell.swift
//  Instagram
//
//  Created by Katie Jiang on 6/28/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: PFImageView!
    
    var post: PFObject! {
        didSet {
            self.photoImageView.file = self.post["media"] as? PFFile
            self.photoImageView.loadInBackground()
        }
    }
}
