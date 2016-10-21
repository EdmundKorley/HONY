//
//  PhotosViewController.swift
//  HONY
//
//  Created by Edmund Korley on 2016-10-17.
//  Copyright © 2016 Edmund Korley. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // tableView where each cell will be a UIImage of a HONY post
    @IBOutlet weak var tableView: UITableView!
    // Here we store the result returned by our request to Tumblr for HONY posts
    public var honyPosts: NSArray?
    // Here we implement a count of the total posts in order to do implement a numbering of posts
    public var totalPosts: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 280
        
        // Here, we fire a network request to the Tumblr Posts Endpoint for the HONY blog meta data
        self.requestHONYPosts()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        // Here, we fire a network request to the Tumblr Posts Endpoint for the HONY blog meta data
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    let subResponseDictionary = responseDictionary["response"] as! NSDictionary
                    self.honyPosts = subResponseDictionary["posts"] as? NSArray
                    self.totalPosts = subResponseDictionary["total_posts"] as? Int
                    self.tableView.reloadData()
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            }
        });
        task.resume()
    }
    
    private func requestHONYPosts() {
        // Here, we fire a network request to the Tumblr Posts Endpoint for the HONY blog meta data
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    let subResponseDictionary = responseDictionary["response"] as! NSDictionary
                    self.honyPosts = subResponseDictionary["posts"] as? NSArray
                    self.totalPosts = subResponseDictionary["total_posts"] as? Int
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Our custom method when given an index, will return the URL as a string
    private func getImageURL(with index: Int) -> String? {
        let post = self.honyPosts?[index] as! NSDictionary
        let photos = post["photos"] as! NSArray
        let photo = photos[0] as! NSDictionary
        let originalSize = photo["original_size"] as! NSDictionary
        let url = originalSize["url"] as! String
        return url
    }
    
    // A custom method to return a string of the unique HONY post URL
    private func getPostID(with index: Int) -> String? {
        return Optional<String>("\(self.totalPosts! - index)")
    }
    
    // A custom method to return the text associated with the photo in the post
    private func getPostText(with index: Int) -> String? {
        let post = self.honyPosts?[index] as! NSDictionary
        var caption = post["caption"] as! String
        caption = caption.replacingOccurrences(of: "<p>", with: "")
        caption = caption.replacingOccurrences(of: "</p>", with: "")
        caption = caption.replacingOccurrences(of: "<br>", with: "")
        caption = caption.replacingOccurrences(of: "</br>", with: "")
        caption = caption.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return caption
    }
    
    // The delegation methods we implement as part of the UITableViewDelegate and UItableViewDataSource protocol
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.Melanchroes.PhotosPrototypeCell", for: indexPath) as! PhotosTableViewCell
        let urlString = self.getImageURL(with: indexPath.row)
        let url = URL(string: urlString!)
        cell.honyImage.setImageWith(url!)
        
        let honyID = self.getPostID(with: indexPath.row)
        cell.honyLabel.text = "#\(honyID!)"
        cell.honyLabel.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.honyPosts {
            return posts.count
        } else {
            return 0
        }
    }

    // Here we pass data into the PhotoDetailsViewController in our prepare for segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pdvc = segue.destination as! PhotoDetailsViewController
        var indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        let urlString = self.getImageURL(with: (indexPath?.row)!)
        let url = URL(string: urlString!)
        pdvc.detailPhotoURL = url
        pdvc.photoDetailNumberMedium = self.getPostID(with: (indexPath?.row)!)
        pdvc.detailsTextViewMedium = self.getPostText(with: (indexPath?.row)!)
    }

    // A routine to remove the gray selection effect.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
}

