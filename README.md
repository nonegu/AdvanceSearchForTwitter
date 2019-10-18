# AdvanceSearchForTwitter
An iOS app that allows user to make advance search on Twitter. 

This app is a part of Udacity iOS Develeoper Nanodegree.

# Dependencies
This project uses couple of dependencies. Those are: OAuthSwift, Realm, Kingfisher, ActiveLabel.

# Installation
1 - In order to build the project successfully, the dependencies included in the dependencies section should be installed first.

2 - To download the dependencies, using Cocoapods are suggested. If you are new to Cocoapods you may get more information on: https://cocoapods.org

3 - To install the pods, create a new Podfile and add following lines below `# Pods for AdvanceSearchForTwitter`
```
pod 'OAuthSwift'
pod 'Kingfisher'
pod 'RealmSwift'
pod 'ActiveLabel'
```
More details on how to install a pod can be found on `Get Started` section here: https://cocoapods.org 

4 - Since the app is incorporated with Twitter API, you need to create your own app at https://developer.twitter.com.
The following callback URL must be included at app creation section:
```
AdvanceSearchForTwitter://
```
5 - Replace the dummy text of your consumer key and consumer secret with your app's in TwitterAPI.swift file.

6 - Deploy it to your device or run it on the simulator!

# How the app works?
- The app requires user authentication on Twitter everytime. No user data is saved on the device. This is the way how Twitter API works.
- When user authenticated, a new user is created with the authenticated user's screen name.
- User is welcomed with the Home screen.
- User can select between 3 tabs: Home, Search, Saved Tweets.
- At home tab the recent 40 tweets on the timeline is requested and shown to the user.
- At search tab, user can select and combine 4 different search types: from, to, hashtag, mentioned. User should also enter a keyword for each search type.
- When user presses search button with appropriate search terms, Search Results are displayed modally. 
- As savedtweets tab, user can see the tweets that have been saved on the device before.
- Each tweet is displayed in a cell with an option button. Depending on the tweet, several options are shown: Retweet, Show on Twitter, Save, Delete and Cancel.
- When user presses `Retweet`, the tweet is retweeted.
- When user presses `Show on Twitter` a Safari View Controller is presented with tweets url.
- When user presses `Save`, selected tweet is saved on the device.
- If the user presses `Delete` on the SearchResultsVC, app will send a request to Twitter API to delete the tweet permanently.
- If the user presses `Delete` on the SavedTweets, selected tweet will be deleted only on the device.
- When user presses `Cancel` the option menu will be dismissed.
