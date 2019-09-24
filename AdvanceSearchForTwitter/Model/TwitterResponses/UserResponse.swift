//
//  UserResponse.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 24.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let name: String
    let screenName: String
    let profileImageUrl: String?
    let profileImageUrlHttps: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case screenName = "screen_name"
        case profileImageUrl = "profile_image_url"
        case profileImageUrlHttps = "profile_image_url_https"
    }
}
