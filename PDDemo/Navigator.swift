//
//  MainCoordinator.swift
//  TestNav
//
//  Created by Euan Macfarlane on 15/11/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

//Delegate used by ViewControllers to find determine which view to push to
protocol NavigationDelegate {
    func navigate(from: Article, to: Article) -> UIViewController
}

class Navigator: NavigationDelegate {
   
    func navigate(from: Article, to: Article) -> UIViewController {
        
        var toVC: UIViewController
       
        if let articleSingle = from as? ArticleSingle {
            let vc = ArticleViewController.instantiate()
            vc.articleSingle = articleSingle
            toVC = vc
            
        } else if let articleList = from as? ArticleList {
            let vc = ArticleListViewController.instantiate()
            vc.articleList = articleList
            vc.navigatorDelegate = self
            toVC = vc
            
        } else if let articleImage = from as? ArticleImage {
            let vc = ArticleImageViewController.instantiate()
            vc.articleImage = articleImage
            toVC = vc
            
        } else {
            //Unknown option so just quit!
            fatalError("Unknown article type")
        }
        
        return toVC
    }
}

////Delegate used by Navigation
//protocol Navigable where Self: UIViewController {
//    var navigatorDelegate: NavigationDelegate? {get set}
//}
