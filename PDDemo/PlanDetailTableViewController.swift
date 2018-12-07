//
//  PlanDetailTableViewController.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 02/11/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class PlanDetailTableViewController: UITableViewController {
    
    var plan : Plan?
    //Check if we have a plan and if so reload the view to show data
    override func viewDidLoad() {
        super.viewDidLoad()
        //If plan set then load data
        if let _ = plan {
            self.navigationItem.title = plan?.text
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    //Set the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return number of groups as sections
        return (plan?.checkListGroups?.count)!
    }

    //Set the number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of checklistitems as number of rows in section
        let rows = plan?.checkListGroups?[section].checkListItems?.count
        return rows!
    }
    
    //Set section header text
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //section header text is that of the group
        let sectionText = plan?.checkListGroups?[section].text
        return sectionText!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanDetailCell", for: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        // Configure the cell...
        if let text = plan?.checkListGroups?[section].checkListItems?[row].text {
            cell.textLabel?.text = text
        }
        if let subTitleText = plan?.checkListGroups?[section].checkListItems?[row].detail {
            cell.detailTextLabel?.text = subTitleText
        } else {
            cell.detailTextLabel?.text = ""
        }
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
