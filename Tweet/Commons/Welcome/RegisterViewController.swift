//
//  RegisterViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 16/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func registerButtonAction() {
        
        performRegister()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        registerButton.layer.cornerRadius = 25
    }
    
    private func performRegister() {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Enter a valid email", style: BannerStyle.warning).show()
            
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Enter a valid name", style: BannerStyle.warning).show()
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Invalid password", style: BannerStyle.warning).show()
            
            return
        }
        
        
    }
}
