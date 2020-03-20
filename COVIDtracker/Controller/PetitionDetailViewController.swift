//
//  PetitionDetailViewController.swift
//  JSONCodables
//
//  Created by Prakhar Prakash Bhardwaj on 06/12/19.
//  Copyright © 2019 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class PetitionDetailViewController: UIViewController {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    @IBOutlet weak var newDeaths: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var activeCases: UILabel!
    @IBOutlet weak var seriousCritical: UILabel!
    
   var _country: String = "-"
   var _totalCases: String = "-"
   var _newCases: String = "-"
   var _totalDeaths: String = "-"
   var _newDeaths: String = "-"
   var _totalRecovered: String = "-"
   var _activeCases: String = "-"
   var _seriousCritical: String = "-"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.country.text = _country
        self.totalCases.text = _totalCases
        self.newCases.text = _newCases
        self.totalDeaths.text = _totalDeaths
        self.newDeaths.text = _newDeaths
        self.totalRecovered.text = _totalRecovered
        self.activeCases.text = _activeCases
        self.seriousCritical.text = _seriousCritical
    }
    
    @IBAction func dismissScreen(_ sender: UIButton){
        self.dismiss(animated: false) {
            print("Dismiss")
        }
    }
}
