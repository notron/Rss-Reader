//
//  BaseCollectionViewController.swift
//  RssReader
//
//  Created by develop-ios on 10/9/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class BaseCollectionViewController : NSObject{
    
    @IBOutlet var collectionView: UICollectionView!
    
    var cellObjects : [NSObject]? = [NSObject]()
    var cellIdentifier : String = ""
    var cellDelegate : DelegateSelectCell?
    
    
    init(objects : [NSObject]?, identifier : String, delegate : DelegateSelectCell?) {
        super.init()
        
        cellObjects = objects
        cellIdentifier = identifier
        cellDelegate = delegate
    }
    
    override init() {
        
    }
}

extension BaseCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if cellObjects != nil {
            return cellObjects!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! BaseCollectionViewCell

        cell.setup(object: (cellObjects?[indexPath.row])!,delegate: cellDelegate)
        
        return cell
    }
}

extension BaseCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)  as! BaseCollectionViewCell
        
        cell.cellSelected()
        
        
    }
}
