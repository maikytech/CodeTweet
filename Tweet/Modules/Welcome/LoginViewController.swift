//
//  LoginViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 16/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - IBActions
    @IBAction func loginButtonAction() {
        
        //Hide the keyboard
        view.endEditing(true)
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
        
        //do the request
        let request = LoginRequest(email: email, password: password)
        
        //Starts loading
        SVProgressHUD.show()
        
        // Sign in configuration
        //performSegue(withIdentifier: "showHome", sender: nil)
        
        //Call the network library
        SN.post(endpoint: EndPoints.login, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
                
            case .success(let user):
                
                NotificationBanner(title: "Success", subtitle: "Welcome \(user.user.names)", style: BannerStyle.success).show()
                
                print("Sucess Login")
                
            case .error(let error):
                return
                //All bad
                
            case .errorResult(let entity):
                 //error manable
                
                return
            }
        }
    }
}
