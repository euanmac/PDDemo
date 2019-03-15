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
    func navigate (to article: Article) -> UIViewController?
}

class Navigator: NavigationDelegate {
    
    //Uses the article to determine what view should be shown next
    //If article has no further content then nil is returned
    func navigate(to article: Article) -> UIViewController? {
        
        var toVC: UIViewController?
        
        //Check if single article with content and if so navigate to show
        if let articleSingle = article as? ArticleSingle {
            if articleSingle.articleContent != nil {
                let vc = ArticleViewController.instantiate()
                vc.articleSingle = articleSingle
                toVC = vc
            }
            
            //Check if article list and if so navigate to view controller
        } else if let articleList = article as? ArticleList {
            let vc = ArticleListViewController.instantiate()
            vc.articleList = articleList
            vc.navigatorDelegate = self
            toVC = vc
            
            //Check if imagearticle with at least some content to show
        } else if let articleImage = article as? ArticleImage {
            if articleImage.articleContent != nil {
                let vc = ArticleImageViewController.instantiate()
                vc.articleImage = articleImage
                toVC = vc
            }
            
        } else {
            //Unknown option so just quit!
            fatalError("Unknown article type")
        }
        
        return toVC
    }

}
