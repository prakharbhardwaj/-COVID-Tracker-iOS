//
//  NewsData.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 19/07/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

// MARK: - NewsDatum
struct NewsDatum: Codable {
    let update, time: String?
}

typealias NewsData = [NewsDatum]
