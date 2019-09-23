//
//  TwitterAPI.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 23.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import OAuthSwift

class TwitterAPI {
    
    static let oauthswift = OAuth1Swift(
        consumerKey:    "eifwSav81IlFFNTefYjSxZR1e",
        consumerSecret: "DzqDJ9ns0h92JW5CoSm36L9qDBzn82u676CBgJvVjGoxGan4OP",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )
    static let callbackURL = URL(string: "AdvanceSearchForTwitter://oauth-callback/twitter")!
    
    class func authorize(viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        TwitterAPI.oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: TwitterAPI.oauthswift)
        #warning("Redirecting with callbackURL does not work atm")
        _ = oauthswift.authorize(withCallbackURL: callbackURL) { (result) in
            print("success")
            switch result {
            case .success( (_, _, _)):
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
}
