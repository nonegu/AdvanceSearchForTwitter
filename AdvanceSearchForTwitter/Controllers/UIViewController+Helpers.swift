//
//  UIViewController+Helpers.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 16.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

extension UIViewController {
    
    // MARK: Alerts
    func displayAlert(title: String, with message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func handleTweet(option: Option) {
        
    }
    
    func save(tweet: Tweet, on realm: Realm, with user: User) {
        let newTweet = SavedTweet()
        do {
            try realm.write {
                newTweet.senderName = tweet.user.name
                newTweet.senderNickname = tweet.user.screenName
                newTweet.text = tweet.fullText
                newTweet.profileImageUrl = tweet.user.profileImageUrlHttps
                user.tweets.append(newTweet)
            }
        } catch {
            displayAlert(title: "Save Error", with: error.localizedDescription)
        }
    }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            print("invalid URL")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
}
