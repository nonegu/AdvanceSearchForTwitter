//
//  SavedTweet.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 17.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation
import RealmSwift

class SavedTweet: Object {
    @objc dynamic var id: String?
    @objc dynamic var text: String?
    @objc dynamic var senderName: String?
    @objc dynamic var senderNickname: String?
    @objc dynamic var profileImageUrl: String?
    var user = LinkingObjects(fromType: User.self, property: "tweets")
}
