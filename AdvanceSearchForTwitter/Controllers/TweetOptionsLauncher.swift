//
//  TweetOptionsLauncher.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 16.10.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class TweetOptionsLauncher: NSObject {
    
    // MARK: Properties
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    var options: [Option] = {
        return [Option(name: .retweet, iconName: .retweet),
                Option(name: .showOnTwitter, iconName: .showOnTwitter),
                Option(name: .save, iconName: .save),
                Option(name: .delete, iconName: .delete),
                Option(name: .cancel, iconName: .cancel)]
    }()
    let cellHeight: CGFloat = 50
    var responsibleViewController: UIViewController?
    
    // show options menu
    func showOptions(on view: UIView) {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissOptionsView)))
        
        view.addSubview(blackView)
        view.addSubview(collectionView)
        
        let height: CGFloat = cellHeight * CGFloat(options.count)
        let y = view.frame.height - height
        collectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        blackView.frame = view.frame
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
    }
    
    @objc func dismissOptionsView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: self.collectionView.frame.maxY, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
    }
    
    override init() {
        super.init()
        
        collectionView.register(UINib(nibName: OptionCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: OptionCell.defaultReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension TweetOptionsLauncher: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.defaultReuseIdentifier, for: indexPath) as! OptionCell
        cell.option = options[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: self.collectionView.frame.maxY, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: { (success) in
            
            let option = self.options[indexPath.row]
            if option.name != .cancel {
                self.responsibleViewController?.handleTweet(option: option)
            }
            
        })
    }
    
}
