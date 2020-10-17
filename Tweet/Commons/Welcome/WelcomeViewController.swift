//
//  WelcomeViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 16/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    //UI configuration.
    func setupUI() {
        
        loginButton.layer.cornerRadius = 25
    }

}
