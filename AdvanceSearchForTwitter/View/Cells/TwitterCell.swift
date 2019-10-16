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
    var tweetData: Tweet? {
        didSet {
            userNickname.text = tweetData!.user.name
            username.text = "@\(tweetData!.user.screenName)"
            tweetText.text = tweetData!.fullText
            let url = tweetData!.user.profileImageUrlHttps
            profileImage.kf.indicatorType = .activity
            profileImage.kf.setImage(with: URL(string: url))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 5
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        // AutoLayout
        setNeedsLayout()
        layoutIfNeeded()
        
        // Tries to fit contentView to the largest size in layoutAttributes
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        // Update layoutAttributes with height that was just calculated
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }

}
