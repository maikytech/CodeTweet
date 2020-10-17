//
//  LoginViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 16/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - IBActions
    
    @IBAction func loginButtonAction() {
        
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    // MARK: - Private Methods
    
    private func setupUI() {
        
        loginButton.layer.cornerRadius = 25
    }
    
    private func performLogin() {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Enter a valid email", style: BannerStyle.warning).show()
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Invalid pasword", style: BannerStyle.warning).show()
            
            return
        }
        
        // Sign in configuration
        
    }

}
