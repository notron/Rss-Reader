//
//  SingleFeedViewController.swift
//  Test
//
//  Created by develop-ios on 8/19/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class SingleFeedViewController: UIViewController{
    
    var feed : Feed!
    
    var isFeedInBookMark : Bool = false
    
    @IBOutlet weak var addBookmarkOutlet: UIBarButtonItem!
    @IBOutlet var descrption: UITextView!
    @IBOutlet var label: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var type: UILabel!
    

    let markHandler : MarkHandler = MarkHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = self.feed.feedTitle
        date.text = self.feed.feedDate
        descrption.text = self.feed.feedDescription
        type.text = self.feed.feedOrigin.label
        
    }
    
    @IBAction func changeMark(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showMarkView", sender: feed)
    }
    
    @IBAction func addBookmark(_ sender: Any) {
        
        CoreDataAPI.shared.NewOrUpdateBookmark(feed: feed) {
            (_ isDuplicate : Bool) in
            if isDuplicate {
                PublicFunc.shared.singleActionAlert(title: "Fault", message: " This Feed already In Bookmark")
            } else {
                feed.feedIsBookMark = true
                PublicFunc.shared.singleActionAlert(title: "Confirmation", message: " This Feed Add To Bookmark")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMarkView"
        {
            if let vc = segue.destination as? MarkViewController {
                vc.feed = sender as! Feed
            }
        }
    }
    
}
