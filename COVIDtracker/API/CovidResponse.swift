//
//  CovidResponse.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 04/05/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

struct CovidRespDatum: Codable {
    let country, totalCases, newCases, totalDeaths: String
    let newDeaths, totalRecovered, newRecovered: String
}

typealias CovidResponse = [CovidRespDatum]
