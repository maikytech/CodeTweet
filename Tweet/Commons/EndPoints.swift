//
//  EndPoints.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 21/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import Foundation

struct EndPoints: Codable {
    
    static let domain = "http://platzi-tweets-backend.herokuapp.com/api/v1"
    static let login = EndPoints.domain + "/auth"
    static let register = EndPoints.domain + "/register"
    static let getPosts = EndPoints.domain + "/posts"
    static let post = EndPoints.domain + "/posts"
    static let delete = EndPoints.domain + "/posts"
}
