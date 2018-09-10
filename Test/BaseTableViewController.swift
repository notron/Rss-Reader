//
//  BaseTableViewController.swift
//  RssReader
//
//  Created by develop-ios on 10/7/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {
    

    @IBOutlet var tableView: BaseUITableView!

    var objects : [NSObject] = [NSObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.setup(rowHeight: 90)
    }
}

extension BaseTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        cell.embedData(feed: self.objects[indexPath.row] as! Feed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
}

extension BaseTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        return []
    }
}
