//
//  PhotoDetailsViewController.swift
//  HONY
//
//  Created by Edmund Korley on 2016-10-20.
//  Copyright © 2016 Edmund Korley. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var detailPhoto: UIImageView!
    var detailPhotoURL: URL?
    var detailsTextViewMedium: String?
    @IBOutlet weak var photoDetailNumber: UILabel!
    var photoDetailNumberMedium: String?
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailPhoto.setImageWith(detailPhotoURL!)
        print(photoDetailNumberMedium)
        self.photoDetailNumber.text!.append(photoDetailNumberMedium!)
        self.detailsTextView.isEditable = false
        detailsTextView.text = detailsTextViewMedium!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
