//
//  File.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 21/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let user: User
    let token: String
    
}
