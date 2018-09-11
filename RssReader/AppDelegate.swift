//
//  AppDelegate.swift
//  Test
//
//  Created by develop-ios on 8/19/17.
//  Copyright © 2017 develop-ios. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let nav1    = UINavigationController()
        let first   = HomeViewController(nibName: "HomeViewController", bundle: nil)
        nav1.viewControllers = [first]
        nav1.tabBarItem = UITabBarItem.init(tabBarSystemItem: .recents, tag: 0)
        
        let nav2    = UINavigationController()
        let second  = BookmarkViewController(nibName: "BookmarkViewController", bundle: nil)
        nav2.viewControllers = [second]
        nav2.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)
        
        let tabs = UITabBarController()
        tabs.viewControllers = [nav1, nav2]
        
        self.window!.rootViewController = tabs
        self.window?.makeKeyAndVisible()
        
        
        
        UITabBar.appearance().tintColor = UIColor.white
        
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)
        
        preloadDBData()
            
        return true
    }
    
    func preloadDBData() {
        
        
        let sqliteURL     = URL(fileURLWithPath: Bundle.main.path(forResource: "CoreData", ofType: "sqlite")!)
        let sqlite_shmURL = URL(fileURLWithPath: Bundle.main.path(forResource: "CoreData", ofType: "sqlite-shm")!)
        let sqlite_walURL = URL(fileURLWithPath: Bundle.main.path(forResource: "CoreData", ofType: "sqlite-wal")!)
        
        let CoreDataSqliteURL = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/CoreData.sqlite")
        let CoreDataSqlite_shmURL = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/CoreData.sqlite-shm")
        let CoreDataSqlite_walURL = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/CoreData.sqlite-wal")
        
        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/CoreData.sqlite") {
            // Copy 3 files
            do {
                try FileManager.default.copyItem(at: sqliteURL, to: CoreDataSqliteURL)
                try FileManager.default.copyItem(at: sqlite_shmURL, to: CoreDataSqlite_shmURL)
                try FileManager.default.copyItem(at: sqlite_walURL, to: CoreDataSqlite_walURL)
                
                print("==============================================")
                print("AppDelegate : PreloadDBData -> FILES COPIED")
                print("==============================================")
                
            } catch {
                print("==============================================")
                print("AppDelegate : PreloadDBData -> ERROR IN COPY OPERATION")
                print("==============================================")
            }
        } else {
            print("==============================================")
            print("AppDelegate : PreloadDBData -> FILES EXIST")
            print("==============================================")
        }
    }
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

