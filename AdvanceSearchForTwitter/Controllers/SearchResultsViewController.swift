//
//  SearchResultsViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 2.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class SearchResultsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var tweets: [Tweet]!
    let realm = try! Realm()
    var user: User?
    lazy var tweetOptionsLauncher: TweetOptionsLauncher = {
        let launcher = TweetOptionsLauncher()
        launcher.responsibleViewController = self
        // homeViewController will not be able to delete any tweets, so delete option removed.
        launcher.options.remove(at: 3)
        return launcher
    }()
    var tweetToBeInteractedWith: Tweet?
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: TwitterCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TwitterCell.defaultReuseIdentifier)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: width, height: 200)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func moreButtonPressed(sender: UIButton) {
        let buttonTag = sender.tag
        tweetToBeInteractedWith = tweets[buttonTag]
        print("more button pressed on cell: \(buttonTag)")
        tweetOptionsLauncher.showOptions(on: (navigationController?.view)!)
    }
    
    override func handleTweet(option: Option) {
        if option.name == "Save" {
            guard let currentTweet = tweetToBeInteractedWith else {
                return
            }
            save(tweet: currentTweet)
        }
    }
    
    func save(tweet: Tweet) {
        let newTweet = SavedTweet()
        do {
            try realm.write {
                newTweet.senderName = tweet.user.name
                newTweet.senderNickname = tweet.user.screenName
                newTweet.text = tweet.fullText
                newTweet.profileImageUrl = tweet.user.profileImageUrlHttps
                user?.tweets.append(newTweet)
            }
        } catch {
            self.displayAlert(title: "Save Error", with: error.localizedDescription)
        }
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitterCell.defaultReuseIdentifier, for: indexPath) as! TwitterCell
        cell.tweetData = tweets[indexPath.row]
        cell.moreButton.addTarget(self, action: #selector(moreButtonPressed(sender:)), for: .touchUpInside)
        cell.moreButton.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}
