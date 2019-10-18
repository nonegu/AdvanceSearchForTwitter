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
    
    func retweet(id: String) {
        TwitterAPI.postForTask(taskName: "Retweet", tweetID: id) { (success, error) in
            if success {
                self.displayAlert(title: "Successful", with: "Retweet completed.")
            } else {
                self.displayAlert(title: "Retweet Error", with: error!.localizedDescription)
            }
        }
    }
    
    func save(tweet: Tweet, on realm: Realm, with user: User) {
        let newTweet = SavedTweet()
        do {
            try realm.write {
                newTweet.senderName = tweet.user.name
                newTweet.senderNickname = tweet.user.screenName
                newTweet.id = tweet.id
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
    
    // MARK: Add an emptyStatus Label to collectionView
    func addEmptyStatusView(with label: UILabel, on collectionView: UICollectionView) {
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.alpha = 0
        let frame = CGRect(x: collectionView.frame.midX-150, y: collectionView.frame.midY-25, width: 300, height: 50)
        view.addSubview(label)
        label.frame = frame
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            label.alpha = 1
        }, completion: nil)
    }
    
    // MARK: Creating an Activity Indicator
    func createActivityIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        indicator.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(indicator)
        return indicator
    }
    
}
