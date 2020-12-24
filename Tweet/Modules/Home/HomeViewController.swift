//
//  HomeViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 28/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getPost()
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPost() {
        
        //Load Indicator
        SVProgressHUD.show()
        
        //Services
        SN.get(endpoint: EndPoints.getPosts) { (response: SNResultWithEntity<[Post], ErrorResponse>) in
            
            //Load Indicator stop
            SVProgressHUD.dismiss()

            switch response {
            case .success(let post):
                self.dataSource = post
                self.tableView.reloadData()
                    
            case .error(let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                
            case .errorResult(let entity):
                NotificationBanner(title: "Warning", subtitle: entity.error, style: .warning).show()
            }
        }
    }
    
    //Delete tweet from server configuration
    private func deletePostAt(indexPath: IndexPath) {
        
        //load indicator
        SVProgressHUD.show()
        
        let postId = dataSource[indexPath.row].id
        let endpoint = EndPoints.delete + postId
        
        //Service
        SN.delete(endpoint: endpoint) { (response: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
            case .success:
                
                //Delete the post from server
                self.dataSource.remove(at: indexPath.row)
                
                //Delete tableView post
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
            case .error(let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                
            case .errorResult(let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
            
            }
        }
    }
}

// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            
            self.deletePostAt(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            
            //Cell configuration
            cell.setupCellWith(post: dataSource[indexPath.row])
            cell.needsToShowVideo = { url in
                
                //Capture video
                let avPLayer = AVPlayer(url: url)
                let avPlayerController = AVPlayerViewController()
                avPlayerController.player = avPLayer
                
                self.present(avPlayerController, animated: true) {
                    
                    //Start the video automatically
                    avPlayerController.player?.play()
                }
            }
        }
        return cell
    }
}

//MARK: - Navigation
extension HomeViewController {
    
    //this will be called when transitions are made between screens (only Storyboards)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if segue.identifier == "showMap", let mapViewController = segue.destination as? MapViewController {
            
            //filter{ $0.hasLocation } = Only post with location.
            mapViewController.post = dataSource.filter{ $0.hasLocation }
        }
    }
}
