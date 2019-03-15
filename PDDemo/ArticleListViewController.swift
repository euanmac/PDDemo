//
//  ArticleListViewController.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 27/11/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

class ArticleListViewController: UITableViewController, UIPopoverPresentationControllerDelegate, Storyboarded {
   
    var articleList : ArticleList?
    var navigatorDelegate: NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Check we have an articleList object
        guard let articleList = articleList else {
            return
        }
        self.title = articleList.articleTitle
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Add notes button if article list
        if articleList.showNotes {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(showNotes(sender:)))
        }
        
        //Load the article data
        self.tableView.reloadData()
    }

    //Notes Button - show notes view controller as a popover
    @objc private func showNotes(sender: UIBarButtonItem) {
        //Check we have a navigation delegate
        if let articleList = articleList {
            
            //If so show the notes controller as a popover
            let vc = ArticleNotesViewController.instantiate()
            vc.articleNote = articleList.note
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            popover.barButtonItem = sender
            popover.delegate = self
            present(vc, animated: true, completion:nil)
        }
    }
    
    //If dismissed by user clicking "away" from the popover, i.e. on the article list VC
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
        guard let articleList = articleList else {
            return
        }
        let articleNotesVC = popoverPresentationController.presentedViewController as! ArticleNotesViewController
        articleList.note = articleNotesVC.articleNote
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //Setting the modal presentation style to none ensures always shown as a popover even on iphone
        return UIModalPresentationStyle.none
    }
    
    //This wont be called as we are always showing as popver - kept just in case notes needs to become full screen again in which case there will need to be some buttons to allow user to dismiss the notes view
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        //let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("dismiss")))
        //navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return articleList!.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let listSection = articleList!.sections[section]
        return articleList!.getArticles(by: listSection).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Get the article selected, first check we have a non-nil list of articles
        if let articleList = articleList {
            
            //Check we have a navigation delegate
            if let navigatorDelegate = navigatorDelegate {
                let listSection = articleList.sections[indexPath.section]
                let article = articleList.getArticles(by: listSection)[indexPath.row]
                
                //Use delegate to get the view controller we should be showing next (if one returned)
                if let vc = navigatorDelegate.navigate(to: article) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //Set section header text
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //section header text is that of the group
        let sectionText = articleList!.sections[section].articleListSectionTitle
        return sectionText!
    }
    
    //Populate the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let listSection = articleList!.sections[indexPath.section]
        let article = articleList!.getArticles(by: listSection)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCheckListCell") as! ArticleCheckListCell

        //Populate the cell text and detail from the article
        cell.update(with: article)

        return cell

    }

    //Set section header colour and text
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(hex: Palette.colour1.rawValue)
            headerView.textLabel?.textColor = UIColor(hex: Palette.colour5.rawValue)
        }
    }
}
