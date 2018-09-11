//
//  ColorCollectionViewCell.swift
//  RssReader
//
//  Created by develop-ios on 9/10/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: BaseCollectionViewCell {
   
    @IBOutlet weak var background: UIView!
    
    override func setup(object : NSObject, delegate: DelegateSelectCell? = nil){
        super.setup(object: object, delegate: delegate)
        let color = object as! Color
        
        background.backgroundColor = UIColor(color.hex)
        
    }
}
