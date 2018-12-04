//
//  HomeTableViewController.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 11/11/2018.
//  Copyright © 2018 pddemo. All rights reserved.
//

import UIKit

//Class to map headers and articles to tableview rows
struct TableViewDataRow : Equatable {

    let headerIndex: Int
    var articleIndex: Int?
    let isVisible: Bool
    let isHeader: Bool
    
    init (headerIndex: Int, isVisible: Bool, isHeader: Bool) {
        self.headerIndex = headerIndex
        self.isVisible = isVisible
        self.isHeader = isHeader
    }
    
    init (headerIndex: Int, articleIndex: Int, isVisible: Bool, isHeader: Bool) {
        self.init(headerIndex: headerIndex, isVisible: isVisible, isHeader: isHeader)
        self.articleIndex = articleIndex
    }
}

class HomeViewController: UITableViewController, Storyboarded {
    
    var navigatorDelegate: NavigationDelegate?
    var dataRows: [TableViewDataRow] = [TableViewDataRow]()
    var headers: [Header] = [Header]()
    var sections: [(header:Header, isCollapsed: Bool)] = [(header:Header, isCollapsed: Bool)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pocket Doctor"
        
        //Get the data - use call back to populate data structures and reload tableview
        ContentfulDataManager.shared.fetchHeaders() { () in
            
            print("\(ContentfulDataManager.shared.headers.count)")
            
            //Initialise local array to store header content, sort by ordinal
            self.headers = ContentfulDataManager.shared.headers
            self.headers.sort() {$0.ordinal < $1.ordinal}
            self.sections = self.headers.map() {($0, true)}
            //Use the headers retrieved to populate table data model
        
            /*Funky code for populating data structure. However as it is  unreadable and tricky to get index from  use old school for loop instead
            self.dataRows = self.headers.map() {TableViewDataRow(id: $0.id, isVisible: true, isHeader: true )}
            self.dataRows = self.headers.reduce([TableViewDataRow]()) {(acc: [TableViewDataRow], header: Header) -> [TableViewDataRow] in
                return acc + [TableViewDataRow(id: header.id, isVisible: true, isHeader: true)] +
                    header.articles.map() {TableViewDataRow(id: $0.id, isVisible: false, isHeader: false)}
            }
            */
            
            //Loop through headers and articles and flatten into the TableViewDataRow structure
            //Assumes empty initiated array
            for (index, header) in self.headers.enumerated() {
                self.dataRows.append(TableViewDataRow(headerIndex: index, isVisible: true, isHeader: true))
                for (aindex, _) in header.articles.enumerated() {
                    self.dataRows.append(TableViewDataRow(headerIndex: index, articleIndex: aindex, isVisible: false, isHeader: false))
                }
            }
            
            //reload the table view on main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headers.count
    }

    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].header.headerTitle
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].isCollapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set row count to be 0 if collapsed or number in section otherwise
        return sections[section].isCollapsed ? 0 : sections[section].header.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        //Get label from article if not nil
        if let title = headers[indexPath.section].articles[indexPath.row].articleTitle {
            cell.textLabel?.text = title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the article selected
        let header = headers[indexPath.section]
        
        
        
        if let articleSingle = header.articles[indexPath.row] as? ArticleSingle {
            let vc = ArticleViewController.instantiate()
            vc.articleSingle = articleSingle
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if let articleList = header.articles[indexPath.row] as? ArticleList {
            let vc = ArticleListViewController.instantiate()
            vc.articleList = articleList
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
                fatalError("Unknown article type")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let section = sender.view!.tag
        let indexPaths = (0..<3).map { i in return IndexPath(item: i, section: section)  }
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

//Extension to implement the click delegate
extension HomeViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ headerView: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].isCollapsed
        
        // Toggle collapse
        sections[section].isCollapsed = collapsed
        headerView.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
