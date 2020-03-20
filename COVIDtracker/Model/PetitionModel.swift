//
//  PetitionModel.swift
//  JSONCodables
//
//  Created by Prakhar Prakash Bhardwaj on 15/11/19.
//  Copyright © 2019 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

// MARK: - CovidDatum
// MARK: - CovidDatum
struct CovidDatum: Codable {
    let country, totalCases, newCases, totalDeaths: String
    let newDeaths, totalRecovered, activeCases, seriousCritical: String
}

typealias CovidData = [CovidDatum]
