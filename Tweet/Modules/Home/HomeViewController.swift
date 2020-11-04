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

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getPost()

    }
    
    //MARK: - Private Methods
    private func setupUI() {
        
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
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            
            //Cell configuration
            cell.setupCellWith(post: dataSource[indexPath.row])
        }
        return cell
    }
}
