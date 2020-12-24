//
//  RegisterRequest.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 21/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    
    let email: String
    let password: String
    let names: String
}
