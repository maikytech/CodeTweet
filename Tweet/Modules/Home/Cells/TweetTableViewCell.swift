//
//  TweetTableViewCell.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 28/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    //cells should never invoke ViewControllers
    
    //MARK: - IBActions
   
    @IBAction func openVideoAction() {
        
        guard let videoUrl = videoUrl else {
            return
        }
        
        needsToShowVideo?(videoUrl)
    }
    
    //MARK: - Properties
    private var videoUrl: URL?
    
    //Block
    var needsToShowVideo: ((_ url: URL) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(post: Post) {
        
        nameLabel.text = post.author.names
        nickNameLabel.text = post.author.nickname
        messageLabel.text = post.text
        videoButton.isHidden = !post.hasVideo
        
        if post.hasImage {
            
            //Image Configuration
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
            
        }else {
            
            tweetImageView.isHidden = true
        }
        
        videoUrl = URL(string: post.videoUrl)
    }
}
