//
//  IndiaTableViewController.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 13/04/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class IndiaTableViewController: UITableViewController {
    
    var lastUpdate = Int(Date().timeIntervalSince1970)
    var now = Int(Date().timeIntervalSince1970)
    var states = StateData()
    var firstSection = StateData()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
    var dateString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshNavDb))
        let newsBtn = UIBarButtonItem(image: UIImage(systemName: "bell.circle"), style: .plain, target: self, action: #selector(getLatestNews))
        
        navigationItem.leftBarButtonItem = newsBtn
        navigationItem.rightBarButtonItem = refreshBtn
        
        self.generateSession()
        self.registerNib()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refreshDb), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func loading(){
        DispatchQueue.main.async {
            let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
            self.navigationItem.rightBarButtonItem = refreshBarButton
            self.navigationItem.title = "Loading..."
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading(){
        DispatchQueue.main.async {
            self.navigationItem.title = "India"
            self.activityIndicator.stopAnimating()
            let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshNavDb))
            self.navigationItem.rightBarButtonItems = [refreshBtn]
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: "PetitionTableViewCell", bundle: nil)
        let nib2 = UINib(nibName: "IndiaDetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PetitionTableViewCell")
        tableView.register(nib2, forCellReuseIdentifier: "IndiaDetailCell")
    }
    
    @objc func refreshDb(){
        now = Int(Date().timeIntervalSince1970)
        if (now - lastUpdate >= 600){
            DispatchQueue.main.async {
                self.generateSession()
            }
        }else{
            print("Do nothing")
        }
    }
    
    @objc func refreshNavDb(){
        DispatchQueue.main.async {
            self.generateSession()
        }
    }
    
    @objc func getLatestNews(){
        let vc = self.storyboard?.instantiateViewController(identifier: "NewsTableViewController") as! NewsTableViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    func generateSession() {
        getdataApi { (res) in
            switch res {
            case .success(let jsonResult):
                DispatchQueue.main.async {
                    self.now = Int(Date().timeIntervalSince1970)
                    self.lastUpdate = self.now
                    self.getCurrTime()
                    self.tableView.isUserInteractionEnabled = false
                    self.states.removeAll()
                    self.firstSection.removeAll()
                    self.states = jsonResult as? StateData ?? []
                    let inIndex = self.states.firstIndex{$0.state == "Total"}
                    self.firstSection.append(self.states[inIndex!])
                    print(self.firstSection)
                    self.tableView.reloadData()
                    self.stopLoading()
                    self.showToast(message: "Feed updated")
                }
            case .failure(let err):
                print("Failed to fetch courses", err.localizedDescription)
                self.stopLoading()
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Oops!", message: "Please check your internet connection", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getdataApi(completion: @escaping (Result<Any, Error>) -> Void) {
        self.loading()
        
        let urlString = "https://prakhar-covid19-api.herokuapp.com/covid19/v2/statewise"
        let urlPath = URL(string: urlString)!
        let urlRequest = URLRequest(url: urlPath)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode(StateData.self, from: data)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
            }        }
        task.resume()
    }
    
    func getCurrTime(){
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        dateString = "Last Update: \(dateFormatter.string(from: date))"
    }
    
    func showToast(message : String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            alert.dismiss(animated: true)
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
        return states.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "PetitionTableViewCell") as! PetitionTableViewCell)
        
        let cellIn = (tableView.dequeueReusableCell(withIdentifier: "IndiaDetailCell") as! IndiaDetailCell)
        
        let firstIndex = firstSection[0]
        let stateIndex = states[indexPath.row]
        
        
        if(indexPath.section == 0) {
            if (firstIndex.newCases == "+0" && firstIndex.newDeaths == "+0" && firstIndex.newRecovered == "+0"){
                cellIn.country.text = firstIndex.state
                cellIn.death.text = firstIndex.totalDeaths
                cellIn.cases.text = firstIndex.totalCases
                cellIn.recovery.text = firstIndex.totalRecovered
                cellIn.newCases.text = ""
                cellIn.newDeath.text = ""
                cellIn.newRecovery.text = ""
            }else{
                cellIn.country.text = firstIndex.state
                cellIn.death.text = firstIndex.totalDeaths
                cellIn.cases.text = firstIndex.totalCases
                cellIn.recovery.text = firstIndex.totalRecovered
                cellIn.newCases.text = firstIndex.newCases.strZero()
                cellIn.newDeath.text = firstIndex.newDeaths.strZero()
                cellIn.newRecovery.text = firstIndex.newRecovered.strZero()
            }
            return cellIn
        } else {
            if (stateIndex.newCases == "+0" && stateIndex.newDeaths == "+0" && stateIndex.newRecovered == "+0"){
                cell.country.text = stateIndex.state
                cell.death.text = stateIndex.totalDeaths
                cell.cases.text = stateIndex.totalCases
                cell.recovery.text = stateIndex.totalRecovered
                cell.newCases.text = ""
                cell.newDeath.text = ""
                cell.newRecovery.text = ""
            }else{
                cell.country.text = stateIndex.state
                cell.death.text = stateIndex.totalDeaths
                cell.cases.text = stateIndex.totalCases
                cell.recovery.text = stateIndex.totalRecovered
                cell.newCases.text = stateIndex.newCases.strZero()
                cell.newDeath.text = stateIndex.newDeaths.strZero()
                cell.newRecovery.text = stateIndex.newRecovered.strZero()
            }
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PetitionDetailViewController") as! PetitionDetailViewController
        
        if(indexPath.section == 0) {
            let inIndex = firstSection[indexPath.row]
            vc._country = inIndex.state
            vc._totalCases = inIndex.totalCases
            vc._newCases = inIndex.newCases.strZero()
            vc._totalDeaths = inIndex.totalDeaths
            vc._newDeaths = inIndex.newDeaths.strZero()
            vc._totalRecovered = inIndex.totalRecovered
            vc._activeCases = inIndex.activeCases
            vc._seriousCritical = inIndex.seriousCritical
            
        } else{
            let stateIndex = states[indexPath.row]
            vc._country = stateIndex.state
            vc._totalCases = stateIndex.totalCases
            vc._newCases = stateIndex.newCases.strZero()
            vc._totalDeaths = stateIndex.totalDeaths
            vc._newDeaths = stateIndex.newDeaths.strZero()
            vc._totalRecovered = stateIndex.totalRecovered
            vc._activeCases = stateIndex.activeCases
            vc._seriousCritical = stateIndex.seriousCritical
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //Put the Last Update detail on the second section:
        if section == 1 {
            return dateString
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
