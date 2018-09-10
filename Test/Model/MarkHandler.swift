//
//  MarkHandler.swift
//  RssReader
//
//  Created by develop-ios on 9/17/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import UIKit

class MarkHandler {
    
    func StringIsValid(string: String) -> String? {
        let validString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if validString != "" {
            return validString
        } else {
            return nil
        }
    }
    
    func newOrUpdateMark(mark: Mark, completion: (_ message: String?) -> Void) {
        
        print("MarkHandler : NewOrUpdateMark -> \(mark.Label!)")
        
        guard let label = StringIsValid(string: mark.Label) else {
            completion("Your Label is Empty.")
            return
        }
        
        if mark.Id != nil {
            CoreDataAPI.shared.updateMark(mark: mark) {
                (message: String?) in
                completion(message)
            }
        } else {
            CoreDataAPI.shared.setNewMark(mark: mark) {
                (message: String?) in
                completion(message)
            }
        }
    }
    
    func getMarks(completion: (_ result: [Mark]) -> Void) {
        
        print("MarkHandler : GetMarks")
        
        CoreDataAPI.shared.getMarkList() {
            (result: [Mark]) in
            completion(result)
        }
        
    }
    
    func deleteMark(mark: Mark, completion: () -> Void) {
        
        print("MarkHandler : DeleteMark -> \(mark.Label)")
        
        CoreDataAPI.shared.deleteMarkDependentBookmark(mark: mark)

        CoreDataAPI.shared.deleteMark(mark: mark) {
            () in
            completion()
        }
        
    }
}
