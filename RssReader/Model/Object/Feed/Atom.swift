//
//  theVerge.swift
//  Test
//
//  Created by develop-ios on 8/29/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation

class Atom : Feed {
    
    init?(object: [String: String],origin: Origin) {
        super.init()
        
        guard let title = object["title"] else {
            return nil
        }
        guard let description = object["content"] else {
            return nil
        }
        guard let date = object["published"] else {
            return nil
        }
        
        CoreDataAPI.shared.isFeedInBookMark(feedTitle: title) {
            (feed: Feed?) in
            if feed != nil {
                feedIsBookMark = true
                feedMarks = feed?.feedMarks
            } else {
                feedIsBookMark = false
            }
        }
        
        feedTitle       = title
        feedDescription = description
        feedDate        = date
        feedOrigin      = origin
        feedOrigin.type = Type.atom
        
    }
    
}
