//
//  ECGTableViewController.swift
//  PocketDoctor
//
//  Created by Euan Macfarlane on 01/11/2018.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

//Subclass of UITableViewCell specifically for populating displaying ECG name and image
class ECGCell : UITableViewCell
{
    @IBOutlet weak var ecgImage: UIImageView!
    @IBOutlet weak var ecgName: UITextView!
}

//Subclass of TableViewController specifically for populating tableview with ECG data
class ECGTableViewController: UITableViewController {

    var ecgs: [ECG]!
    override func viewDidLoad() {
        super.viewDidLoad()

        ContentfulDataManager.shared.fetchECGs() { () in
            
            print("\(ContentfulDataManager.shared.plans.count)")
            self.ecgs = ContentfulDataManager.shared.ecgs
            //reload the table view on main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows
        return ContentfulDataManager.shared.ecgs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ECGCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ECGCell", for: indexPath) as! ECGCell
        let ecg = self.ecgs?[indexPath.row]
        cell.ecgName.text = ecg?.name
        ContentfulDataManager.shared.fetchImage(for: (ecg?.ecgImage)!) { (ecgImage) in
            
            print("\(ContentfulDataManager.shared.plans.count)")
            DispatchQueue.main.async {
                cell.ecgImage.image = ecgImage
                print ("Set image")
                
            }
        }
        //Download image
        print("Returned cell")
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowECGDetail") {
            if let destination = segue.destination as? ECGDetailViewController {
                destination.ecg = ecgs![(self.tableView.indexPathForSelectedRow?.row)!]
            }
        }
        return
    }
 

}
