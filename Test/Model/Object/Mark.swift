//
//  Mark.swift
//  RssReader
//
//  Created by develop-ios on 9/11/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import UIKit
import HexColors


class Mark: NSObject {
    
    internal var Id    : Int!
    internal var Label : String!
    internal var Color : UIColor!
    
    
    init(id: Int, label: String, color: UIColor) {
        Id    = id
        Label = label
        Color = color
    }
    
    override init() {
        
    }

    
}
