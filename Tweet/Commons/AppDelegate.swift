//
//  AppDelegate.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 11/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //We declared window variable
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

