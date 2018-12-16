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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCheckListCell") as! ArticleCheckListTableViewCell

        //Populate the cell text and detail from the article
        cell.update(with: article)

        // Your logic....
        return cell

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
