//
//  SearchResultsViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 2.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var tweets: [Tweet]!
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: TwitterCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TwitterCell.defaultReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
