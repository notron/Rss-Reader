//
//  Feed.swift
//  Test
//
//  Created by develop-ios on 8/29/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation


class Feed: NSObject {

    internal var feedTitle       :String!
    internal var feedDescription :String!
    internal var feedDate        :String!
    internal var feedIsBookMark  :Bool!
    internal var feedMarks       :[Mark]?
    internal var feedOrigin      :Origin = Origin()
    
    init(title: String, description: String, date: String, marks: [Mark]?, origin: Origin, isBookMark : Bool) {
    
        feedTitle       = title
        feedDescription = description
        feedDate        = date
        feedMarks       = marks
        feedOrigin      = origin
        feedIsBookMark  = isBookMark
        
    }
    
    override init() {
        
    }
    
}
