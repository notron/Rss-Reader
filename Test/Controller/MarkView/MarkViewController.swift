//
//  MarkViewController.swift
//  RssReader
//
//  Created by develop-ios on 9/23/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit


extension MarkViewController : DelegateSelectCell {
    
    func selected(object: NSObject?) {
        let color = object as! Color
        newMarkSelectColor.backgroundColor = UIColor(color.hex)
    }
}

class MarkViewController: BaseTableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var insertMarkViewHeight: NSLayoutConstraint!
    @IBOutlet var colorCollectionView: UICollectionView!
    @IBOutlet var newMarkSelectColor: UIView!
    @IBOutlet var newMarkLabel: UITextField!
    @IBOutlet var newMarkButton: UIButton!
    @IBOutlet weak var saveMark: UIButton!
    @IBOutlet var noMark: UILabel!
    
    
    var feed : Feed?
    let markHandler : MarkHandler = MarkHandler()
    
    var currentMark : Mark?
    
    var feedMarks : [Mark] = [Mark]()
    
    var baseCollectionViewController = BaseCollectionViewController()
    
    let colors : [Color] = [Color(hex: "#c0392b"),Color(hex: "#9b59b6"),Color(hex: "#8e44ad"),Color(hex: "#2980b9"),Color(hex: "#1abc9c"),Color(hex: "#16a085"),Color(hex: "#27ae60"),Color(hex: "#2ecc71"),Color(hex: "#f1c40f"),Color(hex: "#f39c12"),Color(hex: "#d35400"),Color(hex: "#bdc3c7"),Color(hex: "#839192")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setup(rowHeight: 50)
        
        baseCollectionViewController = BaseCollectionViewController(objects: colors, identifier: "colorCell", delegate : self)
        colorCollectionView.delegate = baseCollectionViewController
        colorCollectionView.dataSource = baseCollectionViewController
        colorCollectionView.reloadData()
        
        if feed?.feedMarks != nil {
            feedMarks = (feed?.feedMarks)!
        }
        
        if feed == nil {
            saveMark.isHidden = true
        }
        
        markHandler.getMarks() {
            (result: [Mark]?) in
            if result != nil {
                objects = result!
                tableView.reloadData()
            }
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objects.count != 0 {
            noMark.alpha = 0
        } else {
            noMark.alpha = 0.5
        }
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MarkTableViewCell
        
        cell.color.layer.cornerRadius = cell.color.frame.width/2
        let currentFeedMark = objects[indexPath.row] as! Mark
        
        cell.label.text = currentFeedMark.Label
        cell.color.backgroundColor = currentFeedMark.Color
        
        
        if feed != nil {
            var isFind = false
            for mark in feedMarks {
                if mark.Id == currentFeedMark.Id {
                    isFind = true
                }
            }
            if isFind {
                cell.checked.alpha = 0.8
            } else {
                cell.checked.alpha = 0
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if feed != nil {
            var isFind : Int!
            
            for (index, feedMark) in feedMarks.enumerated() {
                let currentFeedMark = objects[indexPath.row] as! Mark
                if feedMark.Id == currentFeedMark.Id {
                    isFind = index
                }
            }
            
            if isFind != nil {
                feedMarks.remove(at: isFind)
            } else {
                feedMarks.append(objects[indexPath.row] as! Mark)
            }
            
            tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            let mark = self.objects[indexPath.row] as! Mark
            self.currentMark = mark
            self.newMarkLabel.text = mark.Label
            self.newMarkSelectColor.backgroundColor = mark.Color
            UIView.animate(withDuration: 0.4, animations: {
                self.insertMarkViewHeight.constant = 150
                self.newMarkButton.transform = CGAffineTransform(rotationAngle: 0.75)
                self.view.layoutIfNeeded()
            })
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            self.markHandler.deleteMark(mark: self.objects[indexPath.row] as! Mark) {
                () in
                self.markHandler.getMarks() {
                    (result: [Mark]?) in
                    if result != nil {
                        self.objects = result!
                        tableView.reloadData()
                    }
                }
            }
        })
        return [deleteAction, editAction]
    }
    
    @IBAction func showInsertMarkView(sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, animations: {
            if self.insertMarkViewHeight.constant == 150 {
                self.insertMarkViewHeight.constant = 40
                self.newMarkButton.transform = CGAffineTransform(rotationAngle: CGFloat(-2*M_PI))
                self.view.layoutIfNeeded()
            } else {
                self.currentMark = Mark()
                self.newMarkLabel.text = ""
                self.newMarkSelectColor.backgroundColor = UIColor.white
                self.insertMarkViewHeight.constant = 150
                self.newMarkButton.transform = CGAffineTransform(rotationAngle: 0.75)
                self.view.layoutIfNeeded()
            }
        })
    }
    
    
    @IBAction func saveFeedMarks(sender: UIButton) {
        
        // if feed is nil this button is Hidden
        // then can call this function certainly feed is not nil
        
        feed?.feedMarks = feedMarks
        
        CoreDataAPI.shared.NewOrUpdateBookmark(feed: feed!) {
            (_ isDuplicate : Bool) in
            
            if isDuplicate {} else {
                feed?.feedIsBookMark = true
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeView(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setNewMark(sender: UIButton) {
        
        view.endEditing(true)
        
        let label = newMarkLabel.text ?? " "
        let color = newMarkSelectColor.backgroundColor ?? UIColor.white
        
        currentMark?.Label = label
        currentMark?.Color = color
        markHandler.newOrUpdateMark(mark: currentMark!) {
            (message: String?) in
            if message == nil {
                UIView.animate(withDuration: 0.4, animations: {
                    self.insertMarkViewHeight.constant = 40
                    self.newMarkButton.transform = CGAffineTransform(rotationAngle: CGFloat(-2*M_PI))
                    self.view.layoutIfNeeded()
                    self.newMarkLabel.text = ""
                    self.newMarkSelectColor.backgroundColor = UIColor.white
                })
                markHandler.getMarks() {
                    (result: [Mark]?) in
                    if result != nil {
                        objects = result!
                        tableView.reloadData()
                    }
                }
            } else {
                PublicFunc.shared.singleActionAlert(title: "Fault", message: message!)
                
            }
        }
    }



}
