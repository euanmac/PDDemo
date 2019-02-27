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
        
    }

    //To be called to refresh ViewController
    func update(with newHeaders: [Header]) {
        
        headers = newHeaders
        
        //Initialise local array to store header content, sort by ordinal
        headers.sort() {$0.ordinal < $1.ordinal}
        sections = self.headers.map() {($0, true)}
        
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

        //Check we have a navigation delegate
        if let navigatorDelegate = navigatorDelegate {
            
            //Use delegate to get the view controller we should be showing next
            if let vc = navigatorDelegate.navigate(to: header.articles[indexPath.row]) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let section = sender.view!.tag
        let indexPaths = (0..<3).map { i in return IndexPath(item: i, section: section)  }
    }
    
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
