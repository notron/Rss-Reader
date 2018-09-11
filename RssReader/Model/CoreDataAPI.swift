//
//  CoreData.swift
//  RssReader
//
//  Created by develop-ios on 9/4/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import UIKit
import HexColors
import CoreData

open class CoreDataAPI {
    public static let shared = CoreDataAPI()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getBookmarkList(completion: (_ result: [Feed]?) -> Void) {
        
        var feeds : [Feed] = []
        
        do {
            let bookmarkTable = try context.fetch(BookmarkTable.fetchRequest()) as [BookmarkTable]
            print("CoreDataAPI : GetBookmarkList -> Fetch All Feed")
            print("CoreDataAPI : GetBookmarkList -> Feeds Count : \(bookmarkTable.count)")
            for record in bookmarkTable{
                
                var origin : Origin?
                var marks  : [Mark] = [Mark]()
                if let result = queryOfSingleResult(entity: "OriginTable", attribute: "label", value: "\(record.origin!)") as? OriginTable{
                    
                    origin = Origin(Label: result.label!, Link: result.link!, Enabled: result.enabled, Type: Type(rawValue: result.type!)!)
                } else {
                    print("CoreDataAPI : GetBookmarkList -> '\(record.label!)' Not Exist Dependet Origin : \(record.origin!)")
                    origin = Origin(Label: record.origin!)
                }
                if record.marks != nil {
                    let marksId = record.marks as! NSArray
                    for markId in marksId {
                        if let result = queryOfSingleResult(entity: "MarkTable", attribute: "uniqueId", value: "\(markId)") as? MarkTable{
                            
                            marks.append(Mark(id: Int(result.uniqueId), label: result.label!, color: UIColor(result.color ?? "#ffffff")!))
                        }
                    }
                }
                
                feeds.append(Feed(title: record.label!, description: record.descript!, date: record.date!, marks: marks, origin: origin!, isBookMark : true))
                
            }
            completion(feeds)
        } catch {
            completion(nil)
            print("CoreDataAPI : GetBookmarkList -> Fetching Failed")
        }
    }
    
    func NewOrUpdateBookmark(feed : Feed, completion: (_ isDuplicate : Bool) -> Void) {
        
        print("CoreDataAPI : NewOrUpdateBookmark -> \(feed.feedTitle!)")
        
        if let result = queryOfSingleResult(entity: "BookmarkTable", attribute: "label", value: feed.feedTitle) as? BookmarkTable{
            
            let marksId : NSMutableArray = []
            if let marks = feed.feedMarks {
                for mark in marks {
                    marksId.add(mark.Id)
                }
                result.marks = marksId
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            completion(true)
            
        } else {
            let record = BookmarkTable(context: context)
            record.label    = feed.feedTitle
            record.descript = feed.feedDescription
            record.date     = feed.feedDate
            record.origin   = feed.feedOrigin.label
            if let marks = feed.feedMarks {
                let marksId : NSMutableArray = []
                for mark in marks {
                    marksId.add(mark.Id)
                }
                record.marks = marksId
            }
            
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
            completion(false)
        }
    }

    func removeBookmark(feed : Feed, completion: () -> Void) {
        
        print("CoreDataAPI : RomoveBookmark -> \(feed.feedTitle!)")
        
        if let result = queryOfSingleResult(entity: "BookmarkTable", attribute: "label", value: feed.feedTitle) as? BookmarkTable{
            
            context.delete(result)
            saveContext()
            completion()
        }
    }
    
    
    func isFeedInBookMark(feedTitle: String, completion: (_ feed: Feed?) -> Void) {
        
        print("CoreDataAPI : isFeedInBookMark -> \(feedTitle)")
        
        if let result = queryOfSingleResult(entity: "BookmarkTable", attribute: "label", value: "\(feedTitle)") as? BookmarkTable{
            
            // is exist, update feed detail
            var origin : Origin!
            var marks  : [Mark] = [Mark]()
            if let originResult = queryOfSingleResult(entity: "OriginTable", attribute: "label", value: "\(result.origin!)") as? OriginTable{
                
                origin = Origin(Label: originResult.label!, Link: originResult.link!, Enabled: originResult.enabled, Type: Type(rawValue: originResult.type!)!)
            } else {
                print("CoreDataAPI : GetBookmarkList -> '\(result.label!)' Not Exist Dependet Origin : \(result.origin!)")
                origin = Origin(Label: result.origin!)
            }
            if result.marks != nil {
                let marksId = result.marks as! NSArray
                for markId in marksId {
                    if let markResult = queryOfSingleResult(entity: "MarkTable", attribute: "uniqueId", value: "\(markId)") as? MarkTable{
                        
                        marks.append(Mark(id: Int(markResult.uniqueId), label: markResult.label!, color: UIColor(markResult.color ?? "#ffffff")!))
                    }
                }
            }
            
            let feed = Feed(title: result.label!, description: result.descript!, date: result.date!, marks: marks, origin: origin, isBookMark : true)
            completion(feed)
        } else {
            completion(nil)
        }
    }
    
    func setNewOrigin(origin : Origin, completion: () -> Void) {
        
        print("CoreDataAPI : SetNewOrigin -> \(origin.label)")
        
        let sourceCore = OriginTable(context: self.context)
        
        sourceCore.label = origin.label
        sourceCore.enabled = origin.enabled
        sourceCore.type = "\(origin.type)"
        sourceCore.link = origin.link
        
        saveContext()
        
        completion()
    }
    
    func deleteOrigin(origin : Origin, completion: () -> Void) {
        
        print("CoreDataAPI : DeleteOrigin -> \(origin.label)")
        
        if let result = queryOfSingleResult(entity: "OriginTable", attribute: "label", value: "\(origin.label)") as? OriginTable{
            
            context.delete(result)
            saveContext()
            completion()
        }
    }
    
//    func deleteBookmarkDependentOrigin(origin : Origin, completion: (_ result: Bool) -> Void) {
//        
//        if let result = query(entity: "BookmarkTable", attribute: "origin", value: "\(origin.label)" as AnyObject) as? [BookmarkTable]{
//            
//            for record in result {
//                context.delete(record)
//                saveContext()
//                completion(true)
//            }
//        }
//    }
    
    
    func toggleOrigin(origin : Origin, completion: () -> Void) {
        
        if let result = queryOfSingleResult(entity: "OriginTable", attribute: "label", value: "\(origin.label)") as? OriginTable{
            
            if result.enabled == true {
                result.enabled = false
            } else {
                result.enabled = true
            }
            saveContext()
            
            print("CoreDataAPI : ToggleOrigin -> \(origin.label) Was Updated")
            completion()
        }
    }
    
    // Get Active Origins
    func getActiveOrigins(completion: (_ result: [Origin]?) -> Void) {
        
        var origins : [Origin] = [Origin]()
        
        if let result = queryOfMultipleResult(entity: "OriginTable", attribute: "enabled", value: true) as? [OriginTable]{
            
            for record in result {
                origins.append(Origin(Label: record.label!, Link: record.link!, Enabled: record.enabled, Type: Type(rawValue: record.type!)!))
            }
            print("CoreDataAPI : GetActiveOrigins -> Origins Result Count : \(origins.count)")
            completion(origins)
        }
    }
    
    // Get All Origins
    func getOriginList(completion: (_ result: [Origin]?) -> Void) {
        
        var origins : [Origin] = []
        do {
            let origintable = try context.fetch(OriginTable.fetchRequest()) as! [OriginTable]
            for record in origintable {
                origins.append(Origin(Label: record.label!, Link: record.link!, Enabled: record.enabled, Type: Type(rawValue: record.type!)!))
            }
            print("CoreDataAPI : GetOriginList -> Origins Result Count : \(origins.count)")
            completion(origins)
        } catch {
            completion(nil)
            print("CoreDataAPI : GetOriginList -> Fetching Failed")
        }
    }
    
    // Get All Marks
    func getMarkList(completion: (_ result: [Mark]) -> Void) {
        
        var marks : [Mark] = []
        do {
            let markCore = try context.fetch(MarkTable.fetchRequest()) as! [MarkTable]
            for record in markCore {
                marks.append(Mark(id: Int(record.uniqueId), label: record.label!, color: UIColor(record.color ?? "#ffffff")!))
            }
            print("CoreDataAPI : GetMarkList -> Marks Result Count : \(marks.count)")
            completion(marks)
        } catch {
            print("CoreDataAPI : GetMarkList -> Fetching Failed")
        }
    }
    
    // Create New Mark
    func setNewMark(mark: Mark, completion: (_ message: String?) -> Void) {
        
        print("CoreDataAPI : SetNewMark -> Mark: \(mark.Label!)")
        
        if let _ = queryOfSingleResult(entity: "MarkTable", attribute: "label", value: mark.Label!) as? MarkTable{
            completion("Your Mark is Duplicate.")
        } else {
            if let id = getUniqueId(entity: "MarkTable", attribute: "uniqueId") {
                let markCore = MarkTable(context: context)
                markCore.label = mark.Label!
                markCore.color = mark.Color!.hex
                markCore.uniqueId = Int32(id)
                saveContext()
                completion(nil)
            }
        }
    }
    
    // Search & Find Current Mark , Change Content
    func updateMark(mark: Mark, completion: (_ message: String?) -> Void) {
        
        print("CoreDataAPI : UpdateMark -> Mark: \(mark.Label!)")
        
        if let result = queryOfSingleResult(entity: "MarkTable", attribute: "uniqueId", value: "\(mark.Id!)") as? MarkTable{
            if let _ = queryOfSingleResult(entity: "MarkTable", attribute: "label", value: "\(mark.Label!)") as? MarkTable{
                completion("Your Mark Label is Duplicate.")
            } else {
                result.label = mark.Label
                result.color = mark.Color.hex
                saveContext()
                completion(nil)
            }
        }
    }
    
    // Search in Entity & Find Last Unique Id , Create Unique
    func getUniqueId(entity: String, attribute: String) -> Int? {
        
        print("CoreDataAPI : GetUniqueId -> Entity: \(entity) || Attribute: \(attribute)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.propertiesToFetch = [attribute]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: attribute, ascending: true)]
        
        do {
            
            let results = try context.fetch(fetchRequest)
            let lastObject = (results as! [NSManagedObject]).last
            guard lastObject != nil else {
                return 1
            }
            return lastObject?.value(forKey: attribute) as! Int + 1
            
        } catch {
            print("CoreDataAPI : GetUniqueId -> Fetching Failed")
            return nil
        }
    }
    
    // Find Bookmark Dependent This Mark and remove Mark in Bookmark`s Marks
    func deleteMarkDependentBookmark(mark : Mark) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookmarkTable")
        
        do {
            let results = try context.fetch(fetchRequest)
            let records = results as! [BookmarkTable]
            for record in records {
                if record.marks != nil {
                    var marksId = record.marks as! [Int]
                    
                    for (index, markId) in marksId.enumerated() {
                        if markId == mark.Id! {
                            marksId.remove(at: index)
                            break
                        }
                    }
                    record.marks = NSMutableArray(array: marksId)
                    saveContext()
                }
            }
            
        } catch {
            print("CoreDataAPI : DeleteMarkDependentBookmark -> Fetching Failed")
        }
    }
    
    // Find Mark in MarkTable & and deleted
    func deleteMark(mark : Mark, completion: () -> Void) {
        
        print("CoreDataAPI : DeleteMark -> \(mark.Label!)")
        
        if let result = queryOfSingleResult(entity: "MarkTable", attribute: "uniqueId", value: "\(mark.Id!)") as? MarkTable{
           
            context.delete(result)
            saveContext()
            completion()
        }
    }
    
    func queryOfSingleResult(entity: String, attribute: String,value: Any) -> NSManagedObject? {
        
        print("CoreDataAPI : QueryOfSingleResult -> Request : Entity: \(entity) || Attribute: \(attribute) || Value: \(value)")
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            //let predicate = NSPredicate(format: "\(attribute) == '\(value)'")
            //let predicate = NSPredicate(format: "\(attribute) == \(value)")
            let predicate = NSPredicate(format: "\(attribute) = %@", argumentArray: [value])
            
            fetchRequest.predicate = predicate
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            
            print("CoreDataAPI : QueryOfSingleResult -> FetchResults Count \(fetchResults.count)")
            return fetchResults.first

        } catch {
            print("CoreDataAPI : QueryOfSingleResult -> Fetching Failed")
            print(error)
            return nil
        }
    }
    
    func queryOfMultipleResult(entity: String, attribute: String,value: Any) -> [NSManagedObject]? {
        
        print("CoreDataAPI : QueryOfMultipleResult -> Request : Entity: \(entity) || Attribute: \(attribute) || Value: \(value)")
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            //let predicate = NSPredicate(format: "\(attribute) == '\(value)'")
            let predicate = NSPredicate(format: "\(attribute) = \(value)")
            
            fetchRequest.predicate = predicate
            let fetchResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            print("CoreDataAPI : QueryOfMultipleResult -> FetchResults Count \(fetchResults.count)")
            return fetchResults
            
        } catch {
            print("CoreDataAPI : QueryOfMultipleResult -> Fetching Failed")
            print(error)
            return nil
        }
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
