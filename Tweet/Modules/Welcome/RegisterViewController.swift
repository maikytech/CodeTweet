//
//  RegisterViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 16/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func registerButtonAction() {
        
        //Hide the keyboard
        view.endEditing(true)
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
        
        guard let names = nameTextField.text, !names.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Enter a valid name", style: BannerStyle.warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Invalid password", style: BannerStyle.warning).show()
            return
        }
        
        //Do the request
        let request = RegisterRequest(email: email, password: password, names: names)
        
        //Starts loading
        SVProgressHUD.show()
        
        //Call the network library
        SN.post(endpoint: EndPoints.register, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            //Stop loading
            SVProgressHUD.dismiss()
            
            switch response {
                
            case .success(let user):
                self.performSegue(withIdentifier: "showHome", sender: nil)
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription,
                                   style: BannerStyle.danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "Warning",
                                   subtitle: entity.error,
                                   style: BannerStyle.warning).show()
            }
        }
    }
}
