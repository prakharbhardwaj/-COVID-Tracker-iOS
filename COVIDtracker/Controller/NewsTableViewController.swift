//
//  NewsTableViewController.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 19/07/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var news = NewsData()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshNavDb))
        navigationItem.rightBarButtonItem = refreshBtn
        
        self.generateSession()
    }
    
    func loading(){
        DispatchQueue.main.async {
            //            let refreshBarButton: UIBarButtonItem = UIBarButtonItem(customView: self.activityIndicator)
            //            self.navigationItem.rightBarButtonItem = refreshBarButton
            //            self.navigationItem.title = "Loading..."
            //            self.activityIndicator.startAnimating()
            self.appDelegate.showProcessingIndicatorOnView(vwBg: self.view, title: "")
            self.tableView.isUserInteractionEnabled = false
        }
    }
    
    func stopLoading(){
        DispatchQueue.main.async {
            //            self.navigationItem.title = "Latest Update"
            //            self.activityIndicator.stopAnimating()
            //            let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshNavDb))
            //            self.navigationItem.rightBarButtonItems = [refreshBtn]
            self.appDelegate.hideProcessingIndicatorFromView(vwBg: self.view)
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    @objc func refreshNavDb(){
        DispatchQueue.main.async {
            self.generateSession()
        }
    }
    
    func generateSession() {
        getdataApi { (res) in
            switch res {
            case .success(let jsonResult):
                DispatchQueue.main.async {
                    self.tableView.isUserInteractionEnabled = false
                    self.news.removeAll()
                    self.news = jsonResult as? NewsData ?? []
                    self.tableView.reloadData()
                    self.stopLoading()
                    self.showToast(message: "News updated")
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
        
        let urlString = "\(API_URL)/covid19/news"
        let urlPath = URL(string: urlString)!
        let urlRequest = URLRequest(url: urlPath)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode(NewsData.self, from: data)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
            }        }
        task.resume()
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell)
        
        let newsIndex = news[indexPath.row]
        
        cell.update.text = newsIndex.update
        cell.time.text = newsIndex.time?.capitalized
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

