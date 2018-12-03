//
//  HeaderTableViewController.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 21/11/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

class HeaderViewController: UITableViewController, Storyboarded {
    var header : Header?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check we have a valid header, if so load the table view
        guard let _ = header else {
            return
        }
        self.title = header?.headerTitle
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return header!.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        cell.textLabel?.text = header?.articles[indexPath.row].articleTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the article selected
        if let articleSingle = header!.articles[indexPath.row] as? ArticleSingle {
            let vc = ArticleViewController.instantiate()
            vc.articleSingle = articleSingle
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if let articleList = header!.articles[indexPath.row] as? ArticleList {
            let vc = ArticleListViewController.instantiate()
            vc.articleList = articleList
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if let articleImage = header!.articles[indexPath.row] as? ArticleImage {
            let vc = ArticleImageViewController.instantiate()
            vc.articleImage = articleImage
            self.navigationController?.pushViewController(vc, animated: true)
        
        } else {
            fatalError("Unknown article type")
        }
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
