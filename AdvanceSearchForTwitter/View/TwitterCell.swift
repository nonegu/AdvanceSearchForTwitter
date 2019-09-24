//
//  TwitterCell.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 24.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class TwitterCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNickname: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var tweetText: UILabel!
    
    static var defaultReuseIdentifier: String {
        return "\(self)"
    }
    
}
