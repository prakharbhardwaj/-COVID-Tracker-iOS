//
//  TodayViewController.swift
//  COVIDtracker Widget
//
//  Created by Prakhar Prakash Bhardwaj on 03/05/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit
import NotificationCenter


enum LoadingState {
    case loading, loaded, failed
}

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var loadingState = LoadingState.loading
    let API = CovidAPI()
    fileprivate var data: Array<NSDictionary> = Array()
    var jsonData = CovidResponse()
    var dateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        self.loadingState = .loading
        self.API.getdataApi { (res) in
            switch res {
            case .success(let jsonResult):
                DispatchQueue.main.async {
                    self.jsonData.removeAll()
                    let data = jsonResult as? CovidResponse ?? []
                    let inIndex = data.firstIndex{$0.country == "India"}
                    let totIndex = data.firstIndex{$0.country == "World"}
                    let usIndex = data.firstIndex{$0.country == "USA"}
                    self.jsonData.append(data[totIndex!])
                    self.jsonData.append(data[inIndex!])
                    self.jsonData.append(data[usIndex!])
                    self.getCurrTime()
                    self.loadingState = .loaded
                    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
                    self.tableView.reloadData()
                    completionHandler(NCUpdateResult.newData)
                }
            case .failure(let err):
                self.loadingState = .failed
                self.tableView.reloadData()
                print("Failed to fetch courses", err.localizedDescription)
                completionHandler(NCUpdateResult.failed)
            }
        }
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: maxSize.width, height: 330)
        }
        else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
    
    // MARK: - Loading of data
    
    //    func loadData() {
    //        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
    //            self.data.removeAll()
    //
    //            if let path = Bundle.main.path(forResource: "Sample", ofType: "plist") {
    //                if let array = NSArray(contentsOfFile: path) {
    //                    for item in array {
    //                        self.data.append(item as! NSDictionary)
    //                    }
    //                }
    //            }
    //
    //            DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
    
    func getCurrTime(){
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm:ss"
        let date = Date()
        dateString = "\(dateFormatter.string(from: date))"
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch loadingState {
        case .loading:
            return 1
        case .failed:
            return 1
        case .loaded:
            return jsonData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "TodayViewCell") as! TodayViewCell)
        
        //        let item = data[indexPath.row]
        //        cell.country.text = item["country"] as? String
        //        cell.recovery.text = item["totalRecovered"] as? String
        //        cell.death.text = item["totalDeaths"] as? String
        //        cell.cases.text = item["totalCases"] as? String
        //
        switch loadingState {
        case .loading:
            cell.status.text = "Loading..."
        case .failed:
            cell.status.text = "Unable to fetch"
            cell.statusLoader.stopAnimating()
            cell.statusLoader.isHidden = true
        case .loaded:
            cell.statusView.isHidden = true
            cell.statusLoader.stopAnimating()
            cell.dataView.isHidden = false
            cell.country.text = jsonData[indexPath.row].country
            cell.death.text = jsonData[indexPath.row].totalDeaths
            cell.cases.text = jsonData[indexPath.row].totalCases
            cell.recovery.text = jsonData[indexPath.row].totalRecovered
            cell.newCases.text = jsonData[indexPath.row].newCases
            cell.newDeath.text = jsonData[indexPath.row].newDeaths
            cell.newRecovery.text = jsonData[indexPath.row].newRecovered
            cell.updateTimeLabel.text = self.dateString        }
        
        return cell
    }
    
}


