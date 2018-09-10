//
//  OriginHandler.swift
//  Test
//
//  Created by develop-ios on 8/21/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import UIKit

class OriginHandler: NSObject{
    
    var allOrigins    : [Origin] = [Origin]()
    var activeOrigins : [Origin] = [Origin]()
    
    func getAllOrigin(completion: @escaping (_ result: [Origin]) -> Void){
        
        print("OriginHandler : GetAllOrigin")
        
        CoreDataAPI.shared.getOriginList() {
            (result: [Origin]?) in
            if result != nil {
                allOrigins = result!
                completion(result!)
            }
        }
    }
    
    func getActiveOrigins(completion: @escaping (_ result: [Origin]) -> Void){
        
        print("OriginHandler : GetActiveOrigins")
        
        CoreDataAPI.shared.getActiveOrigins() {
            (result: [Origin]?) in
            if result != nil {
                activeOrigins = result!
                completion(result!)
            }
        }
    }

    func toggleOrigin(origin: Origin, completion: @escaping (_ result: [Origin]) -> Void) {
        
        print("OriginHandler : ToggleOrigin -> \(origin.label)")
        
        CoreDataAPI.shared.toggleOrigin(origin: origin) {
            () in
            getAllOrigin(){
                (result: [Origin]) in
                completion(result)
            }
        }
    }
    
    func StringIsValid(string: String) -> String? {
        let validString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if validString != "" {
            return validString
        } else {
            return nil
        }
    }
    
    
    func setNewOrigin(label: String, link: String, completion: @escaping (_ message: String?) -> Void) {
        
        print("OriginHandler : SetNewOrigin -> \(label) || \(link)")
    
        guard let label = StringIsValid(string: label) else {
            completion("Your Label is Empty.")
            return
        }
        
        guard let link = StringIsValid(string: link) else {
            completion("Your Link is Empry.")
            return
        }
        
        for origin in allOrigins {
            
            if label == origin.label {
                completion("Your Label is Duplicate.")
                return
            } else if link == origin.link {
                completion("Your Link is Duplicate.")
                return
            }
        }
        
        let origin = Origin(Label: label, Link: link, Enabled: true, Type: Type.rss)
        
        FeedHandler().getFeeds(origin: origin, universalRefresh: false) {
            (result: [Feed]?) in
            
            if result != nil {
                CoreDataAPI.shared.setNewOrigin(origin: result!.first!.feedOrigin) {
                    () in
                    completion(nil)
                }
            } else {
                completion("Your Surse is Not Support.")
            }
        }
    }
    
    
    func deleteOrigin(origin: Origin, completion: () -> Void) {
        
        print("OriginHandler : DeleteOrigin -> \(origin.label)")
        
        CoreDataAPI.shared.deleteOrigin(origin: origin) {
            () in
            completion()
        }
    }
}

enum Type : String {
    
    case rss  = "rss"
    case atom = "atom"
}
