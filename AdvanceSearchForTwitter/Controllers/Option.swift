//
//  Option.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 18.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class Option: NSObject {
    let name: OptionName
    let iconName: OptionIconName
    
    init(name: OptionName, iconName: OptionIconName) {
        self.name = name
        self.iconName = iconName
    }
}

enum OptionName: String {
    case retweet = "Retweet"
    case showOnTwitter = "Show on Twitter"
    case save = "Save"
    case delete = "Delete"
    case cancel = "Cancel"
}

enum OptionIconName: String {
    case retweet = "repeat"
    case showOnTwitter = "paperplane.fill"
    case save = "book.fill"
    case delete = "trash.fill"
    case cancel = "multiply.circle.fill"
}

