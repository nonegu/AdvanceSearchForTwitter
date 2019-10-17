//
//  UIViewController+Helpers.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 16.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Alerts
    func displayAlert(title: String, with message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func handleTweet(option: Option) {
        
    }
    
}
