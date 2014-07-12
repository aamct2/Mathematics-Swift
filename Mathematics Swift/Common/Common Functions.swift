//
//  Common Functions.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/12/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

func propertiesSubset(desiredProperties: [String], #superSet: [String: Bool]) -> [String: Bool] {
    
    var newSet = [String: Bool]()
    
    for prop in desiredProperties {
        if contains(superSet.keys, prop) {
            if superSet[prop] == true {
                newSet[prop] = true
            }
        }
    }
    
    return newSet
}
