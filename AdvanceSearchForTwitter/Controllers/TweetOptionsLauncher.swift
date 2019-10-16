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
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    // show options menu
    func showOptions(on view: UIView) {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissOptionsView)))
        
        view.addSubview(blackView)
        view.addSubview(collectionView)
        
        let height: CGFloat = 200
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
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: self.collectionView.frame.maxY + 200, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
    }
    
    override init() {
        super.init()
        
    }
    
}
