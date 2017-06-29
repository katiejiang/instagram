//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Katie Jiang on 6/28/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var user : PFUser = PFUser.current()!
    var posts : [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection View set up
        collectionView.dataSource = self
        collectionView.delegate = self
        updatePosts()

        // Make profile pic circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        // Collection View Layout
        flowLayout.minimumLineSpacing = 6
        flowLayout.minimumInteritemSpacing = 6
        
        // Hide logout button if not profile doesn't match current user
        if user != PFUser.current() {
            logoutButton.hidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set navigation controller title to current username
        self.navigationController?.navigationBar.topItem?.title = user.username
        nameLabel.text = user["name"] as? String
        bioLabel.text = user["bio"] as? String
        profileImageView.file = user["profilePicture"] as? PFFile
        profileImageView.loadInBackground()
    }
    
    func updatePosts() {
        // Construct query
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: user)
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?,
            error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.collectionView.reloadData()
            } else {
                print(String(describing: error?.localizedDescription))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.size.width
        let numberOfCellsPerRow = 3
        let dimension = CGFloat(Int(totalWidth) / numberOfCellsPerRow) - 4
        return CGSize.init(width: dimension, height: dimension)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoCell
        let vc = segue.destination as! PostDetailsViewController
        vc.post = cell.post
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
}
