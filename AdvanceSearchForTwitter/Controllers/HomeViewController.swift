//
//  HomeViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 23.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    let realm = try! Realm()
    var user: User?
    var tweets = [Tweet]()
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
//        TwitterAPI.get(url: URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=from%3Atwitterdev&result_type=mixed&count=5&tweet_mode=extended")!, completion: handleSearchResults(results:error:))
        TwitterAPI.getUserData(completion: handleUserDataResult(userData:error:))
        TwitterAPI.getTimeline(completion: handleTimelineResults(results:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func handleTimelineResults(results: [Tweet], error: Error?) {
        if error == nil {
            tweets = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            print(error!)
        }
    }
    
    func handleUserDataResult(userData: UserResponse?, error: Error?) {
        if error == nil {
            guard let username = userData?.screenName else {
                print(error!)
                return
            }
            assignUser(name: username)
        } else {
            print(error!)
        }
    }
    
    // check if user exists, if not create a new user
    func assignUser(name: String){
        let users = realm.objects(User.self)
        let currentUser = User()
        currentUser.name = name
        if !users.contains(where: { (user) -> Bool in user.name == currentUser.name }) {
            createNewUser(user: currentUser)
        } else {
            self.user = users.first(where: { (user) -> Bool in user.name == currentUser.name })
        }
    }
    
    func createNewUser(user: User) {
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            displayAlert(title: "Register Error", with: error.localizedDescription)
        }
        self.user = user
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
            guard let currentUser = user else {
                return
            }
            save(realm: realm, user: currentUser, tweet: currentTweet)
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
        cell.moreButton.addTarget(self, action: #selector(moreButtonPressed(sender:)), for: .touchUpInside)
        cell.moreButton.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}
