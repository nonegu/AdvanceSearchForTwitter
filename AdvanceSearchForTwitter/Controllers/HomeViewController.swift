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
        collectionView.register(UINib(nibName: TwitterCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TwitterCell.defaultReuseIdentifier)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: width, height: 200)
        }
        
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
        cell.tweetData = tweets[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}
