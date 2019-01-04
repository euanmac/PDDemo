//
//  ArticleListViewController.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 27/11/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

class ArticleListViewController: UITableViewController, Storyboarded {
   
    var articleList : ArticleList?
    var navigatorDelegate: NavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Check we have an articleList object
        guard let _ = articleList else {
            return
        }
        self.title = articleList?.articleTitle
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Load the article data
        self.tableView.reloadData()
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

        // Your logic....
        return cell

    }

    //Set section header colour and text
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(hex: 0x2E3944)
            headerView.textLabel?.textColor = UIColor.white
        }
    }
}
