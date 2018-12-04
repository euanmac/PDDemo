 //
//  AppDelegate.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 28/10/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Contentful

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cdm = ContentfulDataManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Download headers
        ContentfulDataManager.shared.fetchHeaders() { () in
            DispatchQueue.main.async {
                //TODO: What if offline and no data
                //Once data loaded prepare the GUI on main thread
               self.prepareGUI()
            }
        }
        return true
    }
    
    private func prepareGUI() {
    
        //Get headers, sorted by ordinal
        let headers = ContentfulDataManager.shared.headers.sorted() { $0.ordinal < $1.ordinal}
        
        //Create Home Nav and controller
        let homeNav = UINavigationController()
        let homeVC = HomeViewController.instantiate()
        homeNav.pushViewController(homeVC, animated: false)
        homeNav.title = "Pocket Doctor"
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: (UIImage(imageLiteralResourceName: "second")), tag: 0)
        homeNav.navigationBar.prefersLargeTitles = true
        
        //Get all headers that are to be shown as tabs (i.e. where showOnTab is true)
        //and set up a NavigationView with embedded HeaderViewController
        let navControllers : [UINavigationController] = headers.filter({$0.showOnTab}).enumerated().map() { (index, header) in
            
            //Set up navigation controller
            let nav = UINavigationController()
            let image = UIImage(imageLiteralResourceName: (index % 2 == 0 ? "first" : "second"))
            //Create header table view and give it a header object
            let headerView = HeaderViewController.instantiate()
            headerView.header = header
            nav.pushViewController(headerView, animated: false)
            nav.title = header.headerTitle
            nav.tabBarItem = UITabBarItem(title: header.headerTitle, image: image, tag: index + 1)
            nav.navigationBar.prefersLargeTitles = true
            return nav
        }

        //Get the tabBar controller so that we can set up UI
        let tabBarController = window!.rootViewController as! UITabBarController
        
        //Combine Home view controller with others
        tabBarController.viewControllers = [homeNav] + navControllers
        
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

    func setupUI () {
        
    }
    
}

