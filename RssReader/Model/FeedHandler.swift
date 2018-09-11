//
//  FeedModel.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit
import Foundation


class FeedHandler {
    
    public var feeds : [String: [Feed]] = [:]
    
    internal func getFeeds(origin : Origin, universalRefresh: Bool, completion: @escaping (_ feeds: [Feed]?) -> Void) {
        
        print("FeedHandler : GetFeeds -> UniversalRefresh : \(universalRefresh)  ||  Origin : \(origin.label)")
        if universalRefresh {
            feeds[origin.label] = nil
        }
        
        if let feeds = feeds[origin.label] {
            completion(feeds)
        } else {
            
            NetworkAPI.shared.sendRequest(link: origin.link){
                (response: Data?) in
                
                guard let data = response else {
                    completion(nil)
                    return
                }
                
                ParserAPI().parseFeed(data: data){
                    (rawFeeds: [[String : String]]?) in
                    
                    if rawFeeds != nil {
                        var feeds: [Feed]? = []
                        
                        for object in rawFeeds! {
                            if let rssFeed = Rss(object: object, origin: origin) {
                                feeds?.append(rssFeed)
                            } else if let atomFeed = Atom(object: object, origin: origin) {
                                feeds?.append(atomFeed)
                            } else {
                                feeds = nil
                                completion(feeds)
                                return
                            }
                        }
                        self.feeds[origin.label] = feeds
                        completion(feeds)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func getBookmarkList(completion: @escaping (_ feeds: [Feed]) -> Void) {
        
        print("FeedHandler : GetBookmarkList")
        
        CoreDataAPI.shared.getBookmarkList() {
            (result: [Feed]?) in
            print("FeedHandler : GetBookmarkList -> Feeds Result Count : \(result?.count)")
            if result != nil {
                completion(result!)
            }
        }
    }
    
    func removeBookmark(feed: Feed, completion: () -> Void) {
        
        print("FeedHandler : RemoveBookmark")
        
        CoreDataAPI.shared.removeBookmark(feed: feed) {
            () in
            completion()
        }
    }
    
}
