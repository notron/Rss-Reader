//
//  BookMarksViewController.swift
//  RssReader
//
//  Created by develop-ios on 10/7/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class BookMarksViewController: BaseTableViewController {
    
    
    @IBOutlet var noFeed: UILabel!
    
    let feedHandler : FeedHandler = FeedHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "singleFeed", sender: objects[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove", handler: { (action, indexPath) in
            
            self.feedHandler.removeBookmark(feed: self.objects[indexPath.row] as! Feed) {
                () in
                self.feedHandler.getBookmarkList() {
                    (feeds: [Feed]) in
                    self.objects = feeds
                    self.tableView.reloadData()
                }
            }
        })
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "singleFeed"
        {
            if let vc = segue.destination as? SingleFeedViewController {
                vc.feed = sender as! Feed
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
        feedHandler.getBookmarkList() {
            (feeds: [Feed]) in
            self.objects = feeds
            self.tableView.reloadData()
        }
    }
    

}

