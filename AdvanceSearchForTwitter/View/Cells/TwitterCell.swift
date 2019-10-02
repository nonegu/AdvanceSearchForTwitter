//
//  CustomTwitterCell.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 2.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class TwitterCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    // MARK: Properties
    static var defaultReuseIdentifier: String {
        return "\(self)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
