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
        tweetToBeInteractedWith = tweets[sender.tag]
        // check if the tweetOptionsLauncher has delete option
        // remove delete option if the tweet is not sent by the user
        if tweetOptionsLauncher.options.count == 5 {
            if !(tweetToBeInteractedWith!.user.screenName == user?.name) {
                tweetOptionsLauncher.options.remove(at: 3)
            }
            // if the tweetOptionsLauncher does not have delete option
            // check if the tweet send by the user, if so, add delete option
        } else if tweetToBeInteractedWith!.user.screenName == user?.name {
            tweetOptionsLauncher.options.insert(Option(name: "Delete", iconName: "trash.fill"), at: 3)
        }
        print("more button pressed on cell: \(sender.tag)")
        tweetOptionsLauncher.showOptions(on: (navigationController?.view)!)
    }
    
    override func handleTweet(option: Option) {
        guard let currentTweet = tweetToBeInteractedWith else {
            return
        }
        guard let currentUser = user else {
            return
        }
        if option.name == "Save" {
            save(tweet: currentTweet, on: realm, with: currentUser)
        } else if option.name == "Retweet" {
            retweet(id: currentTweet.id)
        } else if option.name == "Show on Twitter" {
            let url = "https://twitter.com/user/statuses/" + currentTweet.id
            showSafariVC(for: url)
        } else if option.name == "Delete" {
            // ask the user if the deletion should be completed
            let alertVC = UIAlertController(title: "Warning", message: "Tweet will be deleted PERMANENTLY. Are you sure to continue?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
                // ask the user if they would like to keep a copy on the device
                let saveACopyAlertVC = UIAlertController(title: "Save a Copy", message: "Would you like to keep a copy of the tweet on the device?", preferredStyle: .alert)
                saveACopyAlertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                    self.save(tweet: currentTweet, on: self.realm, with: currentUser)
                    self.deletePermanently(id: currentTweet.id)
                }))
                saveACopyAlertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (alert) in
                    self.deletePermanently(id: currentTweet.id)
                }))
                self.present(saveACopyAlertVC, animated: true, completion: nil)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func deletePermanently(id: String) {
        TwitterAPI.postForTask(taskName: "Delete", tweetID: id) { (success, error) in
            if success {
                self.displayAlert(title: "Successful", with: "Tweet permanently deleted.")
            } else {
                self.displayAlert(title: "Delete Error", with: error!.localizedDescription)
            }
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
