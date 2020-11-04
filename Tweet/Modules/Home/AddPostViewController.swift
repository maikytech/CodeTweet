//
//  AddPostViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 3/11/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class AddPostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    
    //MARK: - IBActions
    @IBAction func addPostAction() {
        
        savePost()
    }
    
    @IBAction func dismissAction() {
        
        dismiss(animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Private Methods
    private func savePost() {
        
        //Do request
        let request = PostRequest(text: postTextView.text, imageUrl: nil, videoUrl: nil, location: nil)
        
        //load indicator
        SVProgressHUD.show()
        
        //Post services
        SN.post(endpoint: EndPoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
            
            //dismiss load indicator
            SVProgressHUD.dismiss()
            
            switch response {
                
            case .success:
                
                self.dismiss(animated: true, completion: nil)
                
            case .error(let error):
                
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                
            case .errorResult(let entity):
                
                NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
            }
        }
    }
}
