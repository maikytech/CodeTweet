//
//  PostRequest.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 21/10/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import Foundation

struct PostRequest: Codable {
    
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
