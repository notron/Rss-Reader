//
//  PublicFunc.swift
//  RssReader
//
//  Created by develop-ios on 9/23/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import Foundation
import UIKit

open class PublicFunc {
    public static let shared = PublicFunc()
    
    func singleActionAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        if let presented = rootViewController?.presentedViewController {
            rootViewController = presented
        }
        
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
