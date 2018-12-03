//
//  MainCoordinator.swift
//  TestNav
//
//  Created by Euan Macfarlane on 15/11/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    var tabBarController: UITabBarController { get  }
    func setup()
}

protocol Coordinated {
    var coordinator : Coordinator {get set}
}


//Manages the horizontal navigation within the application
//Creates and uses a navigation controller but will manage the transition along the stack
class NavigationCoordinator: Coordinator {
    var tabBarController: UITabBarController
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var header: Header
    
    //Memberwise initialiser
    init(tabBarController: UITabBarController, header: Header) {
        self.navigationController = UINavigationController()
        self.tabBarController = tabBarController
        self.header = header
    }
    
    func setup() {
        let vc = HeaderViewController.instantiate()
        //vc.coordinator = self
        
    }
    
    func navigateFromHomeToHeader() {
        
    }
    
    func navigateFromHeaderToArticle() {
        
    }
}

class HomeCoordinator: Coordinator {
    var tabBarController: UITabBarController
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var headers: [Header]
    
    //Memberwise initialiser
    init(tabBarController: UITabBarController, headers: [Header]) {
        self.navigationController = UINavigationController()
        self.tabBarController = tabBarController
        self.headers = headers
    }
    
    func setup() {
        let vc = HeaderViewController.instantiate()
        //vc.coordinator = self
    }
    
    func navigateFromHomeToHeader() {
        
    }
    
    func navigateFromHeaderToArticle() {
        
    }
}
