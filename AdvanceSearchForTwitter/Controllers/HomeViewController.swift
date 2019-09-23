//
//  HomeViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 23.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterAPI.oauthswift.client.get(URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=from%3Atwitterdev&result_type=mixed&count=2")!, completionHandler: { (result) in
            switch result {
            case .success(let response):
                let jsonDict = try? response.jsonObject()
                print(String(describing: jsonDict))
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
