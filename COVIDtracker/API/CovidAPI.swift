//
//  CovidAPI.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 04/05/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

class CovidAPI {
    
    func getdataApi(completion: @escaping (Result<Any, Error>) -> Void) {
        
        let urlString = "\(API_URL)/covid19"
        let urlPath = URL(string: urlString)!
        let urlRequest = URLRequest(url: urlPath)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = data else { return }
            do {
                let courses = try JSONDecoder().decode(CovidResponse.self, from: data)
                completion(.success(courses))
            } catch let jsonError {
                completion(.failure(jsonError))
            }        }
        task.resume()
    }
}
