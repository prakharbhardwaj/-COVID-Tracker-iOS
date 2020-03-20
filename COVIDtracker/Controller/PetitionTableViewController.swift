//
//  PetitionTableViewController.swift
//  JSONCodables
//
//  Created by Prakhar Prakash Bhardwaj on 15/11/19.
//  Copyright © 2019 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class PetitionTableViewController: UITableViewController {
    
    var petetions = CovidData()
    var firstSection = CovidData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshDb))
        navigationItem.rightBarButtonItems = [refreshBtn]
    
        self.requestToJson()
        self.registerNib()
    }
    
    func registerNib(){
        let nib = UINib(nibName: "PetitionTableViewCell", bundle: nil)
        let nib2 = UINib(nibName: "IndiaDetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PetitionTableViewCell")
        tableView.register(nib2, forCellReuseIdentifier: "IndiaDetailCell")
    }
    
    @objc func refreshDb(){
        petetions.removeAll()
        firstSection.removeAll()
        self.requestToJson()
    }
    
    func requestToJson() {
        let urlString = "https://prakhar-covid19-api.herokuapp.com/covid19"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(CovidData.self, from: json) {
            petetions = jsonPetitions
            print(petetions)
            DispatchQueue.main.async {
                let inIndex = self.petetions.firstIndex{$0.country == "India"}
                let totIndex = self.petetions.firstIndex{$0.country == "Total:"}
                self.firstSection.append(self.petetions[totIndex!])
                self.firstSection.append(self.petetions[inIndex!])
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstSection.count
        }
        return petetions.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "PetitionTableViewCell") as! PetitionTableViewCell)
        
        let cellIn = (tableView.dequeueReusableCell(withIdentifier: "IndiaDetailCell") as! IndiaDetailCell)
        
        let petitionIndex = petetions[indexPath.row]
        
        if(indexPath.section == 0) {
            cellIn.country.text = firstSection[indexPath.row].country
            cellIn.death.text = firstSection[indexPath.row].totalDeaths
            cellIn.cases.text = firstSection[indexPath.row].totalCases
            cellIn.recovery.text = firstSection[indexPath.row].totalRecovered
            return cellIn
        } else {
            cell.country.text = petitionIndex.country
            cell.death.text = petitionIndex.totalDeaths
            cell.cases.text = petitionIndex.totalCases
            cell.recovery.text = petitionIndex.totalRecovered
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PetitionDetailViewController") as! PetitionDetailViewController
                
        if(indexPath.section == 0) {
            let inIndex = firstSection[indexPath.row]
            vc._country = inIndex.country
            vc._totalCases = inIndex.totalCases
            vc._newCases = inIndex.newCases
            vc._totalDeaths = inIndex.totalDeaths
            vc._newDeaths = inIndex.newDeaths
            vc._totalRecovered = inIndex.totalRecovered
            vc._activeCases = inIndex.activeCases
            vc._seriousCritical = inIndex.seriousCritical
            
        } else{
            let petitionIndex = petetions[indexPath.row]
            vc._country = petitionIndex.country
            vc._totalCases = petitionIndex.totalCases
            vc._newCases = petitionIndex.newCases
            vc._totalDeaths = petitionIndex.totalDeaths
            vc._newDeaths = petitionIndex.newDeaths
            vc._totalRecovered = petitionIndex.totalRecovered
            vc._activeCases = petitionIndex.activeCases
            vc._seriousCritical = petitionIndex.seriousCritical
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        //Put the Last Update detail on the second section:
        if section == 1 {
            return "Last Update: \(dateString)"
        }
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
