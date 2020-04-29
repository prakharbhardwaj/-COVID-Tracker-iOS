//
//  Extension.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 28/04/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

extension String {
    
    func strZero() -> String{
        if (self == "+0" || self.isEmpty){
            return "0"
        } else{
            return self
        }
    }
}
