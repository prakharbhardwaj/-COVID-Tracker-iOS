//
//  StateData.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 13/04/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

// MARK: - StateDatum
struct StateDatum: Codable {
    let state, totalCases, newCases, totalDeaths: String
    let newDeaths, totalRecovered, activeCases, newRecovered: String
    let seriousCritical: String
}

typealias StateData = [StateDatum]
