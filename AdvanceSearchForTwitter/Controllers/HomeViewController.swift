//
//  HomeViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 23.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var tweets = [Tweet]()
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterAPI.get(completion: handleSearchResults(results:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func handleSearchResults(results: [Tweet], error: Error?) {
        if error == nil {
            tweets = results
            print(tweets)
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
        cell.layer.cornerRadius = 5
        return cell
    }
    
    
}
