//
//  HomeViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 23.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    var tweets = [Tweet]()
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
//        TwitterAPI.get(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=from%3Atwitterdev&result_type=mixed&count=5&tweet_mode=extended")!, completion: handleSearchResults(results:error:))
        TwitterAPI.getTimeline(url: URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json?count=40&tweet_mode=extended")!, completion: handleSearchResults(results:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func handleSearchResults(results: [Tweet], error: Error?) {
        if error == nil {
            tweets = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            print(error!)
        }
    }
}

// MARK: UICollectionView Delegate Methods

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitterCell.defaultReuseIdentifier, for: indexPath) as! TwitterCell
        cell.userNickname.text = tweets[indexPath.row].user.name
        cell.username.text = "@\(tweets[indexPath.row].user.screenName)"
        cell.tweetText.text = tweets[indexPath.row].fullText
        let url = tweets[indexPath.row].user.profileImageUrlHttps
        cell.profileImage.kf.indicatorType = .activity
        cell.profileImage.kf.setImage(with: URL(string: url))
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20, height: 180)
    }
    
    
}
