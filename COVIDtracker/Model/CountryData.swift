//
//  CountryData.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 29/03/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

struct CountryData: Codable {
    let country, totalCases, newCases, totalDeaths: String
    let newDeaths, totalRecovered, activeCases, newRecovered: String
    let seriousCritical: String
}
