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
    let state, totalCases, totalDeaths, newDeaths: String
    let newCases, totalRecovered, activeCases, seriousCritical: String
}

typealias StateData = [StateDatum]
