//
//  User.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 17.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var name: String?
    let tweets = List<SavedTweet>()
}
