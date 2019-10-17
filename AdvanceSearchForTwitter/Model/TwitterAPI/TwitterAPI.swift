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
        static let base = "https://api.twitter.com/1.1"
        static let searchBase = "/search/tweets.json?q="
        
        case getTimeline
        case getSearchResults(from: String?, to: String?, hashtag: String?, mentioned: String?)
        
        var stringValue: String {
            switch self {
            case .getTimeline:
                return Endpoints.base + "/statuses/home_timeline.json?count=40&tweet_mode=extended"
            case .getSearchResults(let from, let to, let hashtag, let mentioned):
                var url = Endpoints.base + Endpoints.searchBase
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
    
    class func getTimeline(completion: @escaping ([Tweet], Error?) -> Void) {
        oauthswift.client.get(Endpoints.getTimeline.url, completionHandler: { (result) in
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
