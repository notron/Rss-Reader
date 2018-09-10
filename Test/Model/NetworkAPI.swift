//
//  ParserAPI.swift
//  RssReader
//
//  Created by develop-ios on 9/19/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import Alamofire


class NetworkAPI {
    public static let shared = NetworkAPI()
    
    func sendRequest(link: String, completion: @escaping (_ response: Data?) -> Void) {
        Alamofire.request(link).response { response in
            
            if response.error != nil {
                print("NetworkAPI  : Response Failure! From -> \(link)")
                print("NetworkAPI  : Error -> \(response.error)")
                completion(nil)
            } else if let data = response.data{
                print("NetworkAPI  : Response Success! From -> \(link)")
                completion(data)
                
            }
        }
    }
}
