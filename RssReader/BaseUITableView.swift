//
//  BaseUITableView.swift
//  RssReader
//
//  Created by develop-ios on 10/8/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import UIKit

class BaseUITableView: UITableView {
    
    func setup(rowHeight: Int) {
        
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .none
        self.separatorColor = UIColor.clear
        self.rowHeight = CGFloat(rowHeight)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

