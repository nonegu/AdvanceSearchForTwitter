//
//  ButtonCell.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 26.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var addSearchFieldButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    static var defaultReuseIdentifier: String {
        return "\(self)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
