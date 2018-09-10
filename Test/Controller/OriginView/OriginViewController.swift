//
//  OriginViewController.swift
//  RssReader
//
//  Created by develop-ios on 9/24/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit

class OriginViewController: BaseTableViewController{
    
    @IBOutlet weak var insertOriginViewHeight: NSLayoutConstraint!
    @IBOutlet var newOriginLabel: UITextField!
    @IBOutlet var newOriginLink: UITextField!
    @IBOutlet var newOriginButton: UIButton!
    
    let originHandler : OriginHandler = OriginHandler()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setup(rowHeight: 50)
        
        
        originHandler.getAllOrigin(){
            (result: [Origin]) in
            self.objects = result
            self.tableView.reloadData()
        }
        
//        newOriginLabel.text = "Apple"
//        newOriginLink.text = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
//        
//        newOriginLabel.text = "Benz"
//        newOriginLink.text = "https://www.mercedes-benz.com/en/ressort/mercedes-benz/feed/"
//
//        newOriginLabel.text = "TheVerge"
//        newOriginLink.text = "https://www.theverge.com/apple/rss/index.xml"
//        
//        newOriginLabel.text = "GameSpot"
//        newOriginLink.text = "https://www.gamespot.com/feeds/reviews/"
//        
//        newOriginLabel.text = "Nintendo"
//        newOriginLink.text = "http://www.nintendo.com/feed"
        

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OriginTableViewCell
        
        let record = objects[indexPath.row] as! Origin
        cell.label.text = record.label
        cell.taggelSwitch.setOn(record.enabled, animated:true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        originHandler.toggleOrigin(origin: objects[indexPath.row] as! Origin){
            (result: [Origin]) in
            self.objects = result
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            self.originHandler.deleteOrigin(origin: self.objects[indexPath.row] as! Origin) {
                () in
                self.originHandler.getAllOrigin(){
                    (result: [Origin]) in
                    self.objects = result
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
        })
        return [deleteAction]
    }
    
    @IBAction func closeView(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showInsertOriginView(sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, animations: {
            if self.insertOriginViewHeight.constant == 150 {
                self.insertOriginViewHeight.constant = 40
                self.newOriginButton.transform = CGAffineTransform(rotationAngle: CGFloat(-2*M_PI))
                self.view.layoutIfNeeded()
            } else {
                self.insertOriginViewHeight.constant = 150
                self.newOriginButton.transform = CGAffineTransform(rotationAngle: 0.75)
                self.view.layoutIfNeeded()
            }
        })
    }
    
    @IBAction func setNewOrigin(sender: UIButton) {
        
        let label = newOriginLabel.text ?? " "
        let link  = newOriginLink.text  ?? " "
        
        originHandler.setNewOrigin(label: label,link: link) {
            (message: String?) in
            if (message == nil) {
                
                self.newOriginLabel.text = ""
                self.newOriginLink.text = ""
                UIView.animate(withDuration: 0.4, animations: {
                    self.insertOriginViewHeight.constant = 40
                    self.newOriginButton.transform = CGAffineTransform(rotationAngle: CGFloat(-2*M_PI))
                })
                self.originHandler.getAllOrigin(){
                    (result: [Origin]) in
                    self.objects = result
                    self.tableView.reloadData()
                }
            } else {
                print("OriginViewController : SetNewOrigin Failure! -> \(message!)")
                PublicFunc.shared.singleActionAlert(title: "Fault", message: message!)
            }
        }
    }
}
