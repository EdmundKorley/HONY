//
//  PhotosTableViewCell.swift
//  
//
//  Created by Edmund Korley on 2016-10-17.
//
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var honyImage: UIImageView!
    @IBOutlet weak var honyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
