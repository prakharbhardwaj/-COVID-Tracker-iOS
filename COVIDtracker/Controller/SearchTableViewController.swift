//
//  SearchTableViewController.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 29/03/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    let tableData = countries
    var filteredTableData = [String]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.searchBar.placeholder = "Search Country, State and City"
        resultSearchController.searchBar.searchBarStyle = .minimal
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        navigationItem.searchController = resultSearchController
        
        // Reload the table
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredTableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.font = .boldSystemFont(ofSize: 25)
        cell.textLabel?.text = String(filteredTableData[indexPath.row].split(separator: ",")[0])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let arr = filteredTableData[indexPath.row].split(separator: ",")
        let inIndex = String(arr[safe: 0] ?? "nil")
        let indexClass = String(arr[safe: 1] ?? "nil")
        var indexType = ""
        
        if (indexClass == "nil"){
            indexType = "WD"
        }else if (indexClass == "India"){
            indexType = "IN"
        }else{
            indexType = "ST"
        }
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CountryTableViewController") as! CountryTableViewController
        
        vc._country = inIndex
        vc._state = indexClass
        vc._qryType = indexType
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
