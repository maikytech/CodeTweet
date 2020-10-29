//
//  TweetTableViewCell.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 28/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(post: Post) {
        
        
        
    }
    
}
