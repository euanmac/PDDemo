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
    var navigatorDelegate: NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check we have a valid header, if so load the table view
        guard let header = header else {
            return
        }
        self.title = header.headerTitle
        // Refresh control add in tableview.
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.tableView.reloadData()
    }

    @objc func refresh(_ sender: Any) {
        // Call webservice here after reload tableview.
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
        
        //Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        //Get the article selected
        if let header = header {
        
            //Check we have a navigation delegate
            if let navigatorDelegate = navigatorDelegate {
                
                //Use delegate to get the view controller we should be showing next
                if let vc = navigatorDelegate.navigate(to: header.articles[indexPath.row]) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
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
