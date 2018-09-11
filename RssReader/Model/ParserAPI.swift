//
//  ParserModel.swift
//  RssReader
//
//  Created by develop-ios on 8/29/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import Alamofire

class ParserAPI: NSObject,XMLParserDelegate{
    
    private var foundCharacters     : String = ""
    private var currentElement      : [String] = []
    private var currentElementCount : Int = 0
    private var object              : [String : String] = [:]
    private var rawFeeds            : [[String : String]]?
    private var parser : XMLParser?
    
    public func parseFeed(data: Data, completion: (_ rawFeeds: [[String : String]]?) -> Void) {
        
        rawFeeds = []
        
        parser = XMLParser(data: data)
        parser?.delegate = self
        
        if (parser?.parse())! {
            print("ParserAPI   : Parse Success!")
            completion(rawFeeds!)
        } else {
            print("ParserAPI   : Parse Failure!")
            print("ParserAPI   : Error -> \(parser?.parserError)")
            completion(nil)
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement.append(elementName)
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // Append found characters to variable
        foundCharacters += string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if currentElementCount > currentElement.count {
            if object["title"] != nil {
                rawFeeds!.append(object)
                object = [:]
            }
        } else {
            if elementName == currentElement.last {
                currentElementCount = currentElement.count
                
                let str = foundCharacters.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                let pureString:String = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                currentElement.removeLast()
                object[elementName] = pureString
            }
        }
        
        foundCharacters = ""
    }
}
