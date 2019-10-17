//
//  SavedTweetsViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 7.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class SavedTweetsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var tweets: Results<SavedTweet>?
    var user: User? {
        get {
            return (self.tabBarController!.viewControllers![0] as! HomeViewController).user
        }
    }
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: TwitterCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TwitterCell.defaultReuseIdentifier)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: width, height: 200)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadTweets()
    }
    
    func loadTweets() {
        tweets = user?.tweets.sorted(byKeyPath: "senderName")
        collectionView.reloadData()
    }
    
}

extension SavedTweetsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tweets!.count == 0 {
            return 1
        } else {
            return tweets!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitterCell.defaultReuseIdentifier, for: indexPath) as! TwitterCell
        if tweets!.count == 0 {
            cell.userNickname.text = ""
            cell.username.text = ""
            cell.tweetText.text = "No tweets saved yet!"
            cell.tweetText.textAlignment = .center
        } else {
            let data = Tweet(fullText: tweets![indexPath.row].text!,
                             user: UserResponse(name: tweets![indexPath.row].senderName!,
                                                screenName: tweets![indexPath.row].senderNickname!,
                                                profileImageUrl: tweets![indexPath.row].profileImageUrl!,
                                                profileImageUrlHttps: tweets![indexPath.row].profileImageUrl!),
                             retweetCount: 0,
                             favoriteCount: 0)
            cell.tweetData = data
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    
}
