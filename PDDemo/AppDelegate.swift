 //
//  AppDelegate.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 28/10/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Contentful

 enum Palette: Int {
    case colour1 = 0x2E3944 //Dark blue (Onyx)
    case colour2 = 0x4E6E5D //Dark green (Storm Cloud)
    case colour3 = 0xDB324D //Red (Rusty Red)
    case colour4 = 0xA29C9B //Grey (Spanish Grey)
    case colour5 = 0xFFFFFF //White
 }
 
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cdm = ContentfulDataManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //Create Home Nav and controller and give it a navigator object as delegate
        UITabBar.appearance().tintColor = UIColor(hex: Palette.colour3.rawValue) //0xA62639,0xA29C9B,0x2E3944,0xD1D1D1,0x4E6E5D
        let homeNav = UINavigationController()
        let homeVC = HomeViewController.instantiate()
        let navigator = Navigator()
        homeVC.navigatorDelegate = navigator
        
        //Show home table view
        homeNav.pushViewController(homeVC, animated: false)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: (UIImage(imageLiteralResourceName: "second")), tag: 0)
        homeNav.navigationBar.prefersLargeTitles = true
        homeNav.navigationBar.tintColor = UIColor(hex: Palette.colour3.rawValue)
        
        
        //Get the tabBar controller so that we can initialise UI
        let tabBarController = window!.rootViewController as! UITabBarController
        tabBarController.viewControllers = [homeNav]
        //tabBarController.tabBar.items?[0].title = "Home"
        homeNav.navigationItem.title = "Pocket Doctor"
        
        //Download headers
        ContentfulDataManager.shared.fetchHeaders() { () in
            DispatchQueue.main.async {
                //TODO: What if offline and no data
                //Once data loaded prepare the GUI on main thread
               self.updateGUI()
            }
        }
        return true
    }
    
    private func updateGUI() {
    
        //Get headers, sorted by ordinal and filtered to only include those that need to be shown on tab bar
        let headers = ContentfulDataManager.shared.headers.sorted(by: {$0.ordinal < $1.ordinal}).filter({$0.showOnTab})
        let navigator = Navigator()
        
        //Get all headers that are to be shown as tabs (i.e. where showOnTab is true)
        //and set up a NavigationView with embedded HeaderViewController
        let navControllers : [UINavigationController] = headers.enumerated().map { (index, header) in
            
            //Set up navigation controller
            let nav = UINavigationController()
            nav.navigationBar.tintColor = UIColor(hex: Palette.colour3.rawValue)
            let image = UIImage(imageLiteralResourceName: (index % 2 == 0 ? "first" : "second"))
            //Create header table view and give it a header object
            let headerView = HeaderViewController.instantiate()
            headerView.header = header
            headerView.navigatorDelegate = navigator
            nav.pushViewController(headerView, animated: false)
            nav.title = header.headerTitle
            nav.tabBarItem = UITabBarItem(title: header.headerTitle, image: image, tag: index + 1)
            nav.navigationBar.prefersLargeTitles = true
            return nav
        }

        //Get the tabBar controller so that we can set up UI
        let tabBarController = window!.rootViewController as! UITabBarController
        
        //Combine Home view controller with others
        tabBarController.viewControllers! += navControllers as [UIViewController]
        
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

