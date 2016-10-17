//
//  PhotosViewController.swift
//  HONY
//
//  Created by Edmund Korley on 2016-10-17.
//  Copyright © 2016 Edmund Korley. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    // tableView where each cell will be a UIImage of a HONY post
    @IBOutlet weak var tableView: UITableView!
    // Here we store the result returned by our request to Tumblr for HONY posts
    public var honyPosts: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    print("[DEBUG HONY response as NSArray]: \(self.honyPosts)")
                }
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

