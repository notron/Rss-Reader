//
//  MarksCollectionViewCell.swift
//  RssReader
//
//  Created by develop-ios on 9/18/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class MarksCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    override func setup(object : NSObject, delegate: DelegateSelectCell? = nil){
        super.setup(object: object)
        let mark = object as! Mark
        
        label.text = mark.Label
        label.backgroundColor = mark.Color
        
    }
    
}
