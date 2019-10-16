//
//  SavedTweetsViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 7.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class SavedTweetsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: TwitterCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TwitterCell.defaultReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}

extension SavedTweetsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tweets.count == 0 {
            return 1
        } else {
            return tweets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitterCell.defaultReuseIdentifier, for: indexPath) as! TwitterCell
        if tweets.count == 0 {
            cell.userNickname.text = ""
            cell.username.text = ""
            cell.tweetText.text = "No tweets saved yet!"
            cell.tweetText.textAlignment = .center
        } else {
            cell.tweetData = tweets[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tweets.count == 0 {
            return CGSize(width: collectionView.frame.size.width - 20, height: 100)
        } else {
            return CGSize(width: collectionView.frame.size.width - 20, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    
}
