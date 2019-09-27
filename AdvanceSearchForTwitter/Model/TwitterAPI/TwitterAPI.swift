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
    
    var isFirstQuery = true
    
    enum Endpoints {
        static let searchBase = "https://api.twitter.com/1.1/search/tweets.json?q="
        
        case getSearchResults(from: String?, to: String?, hashtag: String?, mentioned: String?)
        
        var stringValue: String {
            switch self {
            case .getSearchResults(let from, let to, let hashtag, let mentioned):
                var url = Endpoints.searchBase
                if let from = from {
                    url += "from%3A\(from)&"
                }
                if let to = to {
                    url += "to%3A\(to)&"
                }
                if let hashtag = hashtag {
                    url += "%23\(hashtag)&"
                }
                if let mentioned = mentioned {
                    url += "%40\(mentioned)&"
                }
                return (url + "tweet_mode=extended")
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func authorize(viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: TwitterAPI.oauthswift)
        oauthswift.authorize(withCallbackURL: callbackURL) { (result) in
            switch result {
            case .success( (_, _, _)):
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    class func get(searchParameters: [String: String], completion: @escaping ([Tweet], Error?) -> Void) {
        
        oauthswift.client.get(TwitterAPI.Endpoints.getSearchResults(from: searchParameters["from"], to: searchParameters["to"], hashtag: searchParameters["hashtag"], mentioned: searchParameters["mentioned"]).url, completionHandler: { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode(SearchResponses.self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedResponse.statuses, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    class func getTimeline(url: URL, completion: @escaping ([Tweet], Error?) -> Void) {
        oauthswift.client.get(url, completionHandler: { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode([Tweet].self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedResponse, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
