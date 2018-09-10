//
//  BaseCollectionViewCell.swift
//  RssReader
//
//  Created by develop-ios on 10/9/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

protocol DelegateSelectCell {
    
    func selected(object : NSObject?)
}


class BaseCollectionViewCell: UICollectionViewCell {
    
    var delegateSelectCell : DelegateSelectCell?
    var object : NSObject? = nil
    
    func setup(object : NSObject, delegate: DelegateSelectCell? = nil){
        
        self.object = object
        delegateSelectCell = delegate
    }
    
    func cellSelected() {
        delegateSelectCell?.selected(object: object)
    }
    
}
