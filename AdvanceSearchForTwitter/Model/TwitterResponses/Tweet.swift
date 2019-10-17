//
//  Tweet.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 24.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct Tweet: Codable {
    let fullText: String
    let user: UserResponse
    let retweetCount: Int
    let favoriteCount: Int
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case fullText = "full_text"
        case user
        case retweetCount = "retweet_count"
        case favoriteCount = "favorite_count"
        case id = "id_str"
    }
}
