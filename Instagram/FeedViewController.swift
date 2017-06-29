//
//  FeedViewController.swift
//  Instagram
//
//  Created by Katie Jiang on 6/27/17.
//  Copyright © 2017 Katie Jiang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts : [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Table View
        tableView.dataSource = self
        tableView.delegate = self
        updatePosts()
        
        // Set navigation bar title as instagram logo
        let image = UIImage(named: "instagram_logo.png")
        self.navigationItem.titleView = UIImageView(image: image)
        
        // Set up Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func updatePosts() {
        // Construct query
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.limit = 20
        query.includeKey("author")
        
        // Fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?,
            error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print(String(describing: error?.localizedDescription))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        cell.usernameButton.tag = indexPath.row
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        updatePosts()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "profileSegue" {
                let vc = segue.destination as! ProfileViewController
                let button = sender as! UIButton
                vc.user = posts[button.tag]["author"] as! PFUser
            }
        }
    }
    
}
