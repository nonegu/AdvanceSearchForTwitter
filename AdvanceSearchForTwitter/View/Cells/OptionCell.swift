//
//  OptionCell.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 16.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var optionIcon: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    
    // MARK: Properties
    var option: Option? {
        didSet {
            optionName.text = option?.name
            if let icon = UIImage(systemName: option!.iconName)?.withRenderingMode(.alwaysTemplate) {
                optionIcon.image = icon
                if option?.name == "Delete" {
                    optionName.textColor = UIColor.red
                    optionIcon.tintColor = UIColor.red
                } else {
                    optionIcon.tintColor = UIColor.black
                }
            }
        }
    }
    
    static var defaultReuseIdentifier: String {
        return "\(self)"
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.5206601024, green: 0.4249630868, blue: 0.6541044116, alpha: 1) : UIColor.white
            if optionName.text == "Delete" {
                optionIcon.tintColor = isHighlighted ? UIColor.white : UIColor.red
                optionName.textColor = isHighlighted ? UIColor.white : UIColor.red
            } else {
                optionIcon.tintColor = isHighlighted ? UIColor.white : UIColor.black
                optionName.textColor = isHighlighted ? UIColor.white : UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
