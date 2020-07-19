//
//  VersionUpdate.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 02/05/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation
import UIKit

struct UpdateResult: Codable {
    let status: Bool
    let message: String
    let url: String?
}

class VersionUpdate: UITableViewController {
    
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    
    func generateAPISession() {
        getVersionApi { (res) in
            switch res {
            case .success(let jsonResult):
                DispatchQueue.main.async {
                    let data = jsonResult as! UpdateResult
                    
                    if(!data.status){
                        let ac = UIAlertController(title: "New Version Available", message: data.message, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "No, Thanks", style: .default, handler: nil))
                        ac.addAction(UIAlertAction(title: "Update Now", style: .default) { (_) in
                            let urlStr = data.url
                            
                            UIApplication.shared.open(URL(string: urlStr!)!, options: [:], completionHandler: nil)
                        })
                        self.present(ac, animated: true, completion: nil)
                    }else{
                        print("Latest app version")
                    }
                }
            case .failure(let err):
                print("err:", err.localizedDescription)
            }
        }
    }
    
    func getVersionApi(completion: @escaping (Result<Any, Error>) -> Void) {
        
        let urlString = "https://prakhar-covid19-api.herokuapp.com/covid19/ios/update?version=\(appVersion)"
        print(urlString)
        let urlPath = URL(string: urlString)!
        let urlRequest = URLRequest(url: urlPath)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(UpdateResult.self, from: data)
                completion(.success(result))
            } catch let jsonError {
                completion(.failure(jsonError))
            }        }
        task.resume()
    }
}

