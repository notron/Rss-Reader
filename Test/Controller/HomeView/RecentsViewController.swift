//
//  RecentsViewController.swift
//  Test
//
//  Created by develop-ios on 8/19/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit
import HexColors

class RecentsViewController: BaseTableViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var segmentHeight: NSLayoutConstraint!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var typetoggleButton: UIButton!
    @IBOutlet var noFeed: UILabel!
    
    
    let originHandler : OriginHandler = OriginHandler()
    let feedHandler   : FeedHandler   = FeedHandler()
    
    var activeOrigin : [Origin] = [Origin]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        originHandler.getActiveOrigins(){
            (result: [Origin]) in
            self.activeOrigin = result
            self.reloadSegment()
            if self.activeOrigin.count != 0 {
                self.reloadFeeds(origin: self.activeOrigin.first!, universalRefresh: false)
                self.segmentedControl.selectedSegmentIndex = 0
            } else {
                self.objects = []
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "singleFeed", sender: objects[indexPath.row])
    }
    
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        resetTableDataSourse()
        
        let selectedIndex = tabBarController!.selectedIndex
        if selectedIndex == 0 {
            
            reloadFeeds(origin: activeOrigin[segmentedControl.selectedSegmentIndex], universalRefresh: true)
        }
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        resetTableDataSourse()
        
        reloadFeeds(origin: activeOrigin[sender.selectedSegmentIndex], universalRefresh: false)
    }
    
    @IBAction func showOriginView(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showOriginView", sender: sender)
    }
    

    @IBAction func showMarkView(_ sender: UIButton) {
       
        performSegue(withIdentifier: "showMarkView", sender: sender)
    }
    
    func reloadSegment() {
        
        segmentedControl.removeAllSegments()
        if activeOrigin.count > 1 {
            
            for (index, origin) in activeOrigin.enumerated() {
                segmentedControl.insertSegment(withTitle: "\(origin.label)", at: index, animated: false)
            }
            segmentedControl.alpha = 1
            segmentHeight.constant = 25
        } else {
            segmentedControl.alpha = 0
            segmentHeight.constant = 0
        }
    }
    
    func reloadFeeds(origin: Origin, universalRefresh: Bool) {
        feedHandler.getFeeds(origin: origin, universalRefresh: universalRefresh) {
            (feeds: [Feed]?) in
            if feeds != nil {
                self.objects = feeds!
                self.tableView.reloadData()
                self.noFeed.alpha = 0
            } else {
                self.noFeed.alpha = 0.5
            }
            self.activity.stopAnimating()
            self.activity.alpha = 0
        }
    }
    
    func resetTableDataSourse() {
        
        objects = []
        tableView.reloadData()
        UIView.animate(withDuration: 0.4, animations: {
            self.activity.startAnimating()
            self.activity.alpha = 1
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "singleFeed"
        {
            if let vc = segue.destination as? SingleFeedViewController {
                vc.feed = sender as! Feed
            }
        }
    }
    
}
