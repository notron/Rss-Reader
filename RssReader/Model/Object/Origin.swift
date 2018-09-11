//
//  Origin.swift
//  Test
//
//  Created by develop-ios on 8/26/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation

class Origin: NSObject {
    
    var label     : String = ""
    var link      : String = ""
    var enabled : Bool = false
    var type      : Type = Type.rss
    
    
    init(Label: String, Link: String, Enabled: Bool, Type: Type) {
        
        label     = Label
        link      = Link
        enabled   = Enabled
        type      = Type
    }
    
    init(Label: String) {
        
        label     = Label
        
    }
    
    override init() {
        
    }
}


