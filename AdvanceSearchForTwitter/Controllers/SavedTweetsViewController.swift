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
    var notificationToken: NotificationToken? = nil
    lazy var tweetOptionsLauncher: TweetOptionsLauncher = {
        let launcher = TweetOptionsLauncher()
        launcher.responsibleViewController = self
        // SavedTweetsViewController will not be able to save any tweets, so save option removed.
        launcher.options.remove(at: 2)
        return launcher
    }()
    var tweetToBeInteractedWith: SavedTweet?
    
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
        
        loadItems()
    }
    
    func loadItems() {
        tweets = user?.tweets.sorted(byKeyPath: "senderName")
        subscribeToRealmNotifications()
    }
    
    func subscribeToRealmNotifications() {
        notificationToken = tweets!.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UICollectionView
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    self?.collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    self?.collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    @objc func moreButtonPressed(sender: UIButton) {
        let buttonTag = sender.tag
        tweetToBeInteractedWith = tweets?[buttonTag]
        print("more button pressed on cell: \(buttonTag)")
        tweetOptionsLauncher.showOptions(on: (navigationController?.view)!)
    }
    
    override func handleTweet(option: Option) {
        if option.name == "Delete" {
            guard let currentTweet = tweetToBeInteractedWith else {
                return
            }
            delete(tweet: currentTweet)
        }
    }
    
    func delete(tweet: SavedTweet) {
        do {
            try self.realm.write {
                self.realm.delete(tweet)
            }
        } catch {
            displayAlert(title: "Error deleting tweet", with:"\(error.localizedDescription)")
        }
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
            cell.moreButton.addTarget(self, action: #selector(moreButtonPressed(sender:)), for: .touchUpInside)
            cell.moreButton.tag = indexPath.row
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
