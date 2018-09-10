//
//  FeedTableViewCell.swift
//  Test
//
//  Created by develop-ios on 8/19/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var marksCollectionView: UICollectionView!
    @IBOutlet var descrption: UITextView!
    @IBOutlet var miniView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var type: UILabel!
    
    var baseCollectionViewController = BaseCollectionViewController()
    
    //var marks : [Mark]?
    
    func embedData(feed: Feed){
        
        baseCollectionViewController = BaseCollectionViewController(objects: feed.feedMarks, identifier: "feedMarkCell", delegate : nil)
        marksCollectionView.delegate = baseCollectionViewController
        marksCollectionView.dataSource = baseCollectionViewController
        marksCollectionView.reloadData()
        
        label.text = feed.feedTitle
        descrption.text = feed.feedDescription
        type.text = "  \(feed.feedOrigin.label)  "
        miniView.layer.cornerRadius = miniView.frame.width/2
        
    }

}
