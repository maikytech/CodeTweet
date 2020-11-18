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
        
        //Show load Indicator
        SVProgressHUD.show()
        
        // Sign in configuration
        //performSegue(withIdentifier: "showHome", sender: nil)
        
        //Call the network library
        SN.post(endpoint: EndPoints.login, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            //Dismiss load indicator
            SVProgressHUD.dismiss()
            
            switch response {
                
            case .success(let user):
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription,
                                   style: BannerStyle.danger).show()
                
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: BannerStyle.warning).show()
            }
        }
    }
}
