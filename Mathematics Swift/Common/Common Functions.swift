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

/**
*  Finds all factors of a given number.
*
*  @param num The number for which to find the factors.
*
*  @return All factors of a given number.
*/
func findFactors(num: Int) -> [Int] {
    var result = [1]
    
    for index in 2 ... num {
        if num % index == 0 {
            // We found a factor
            result += index
        }
    }
    
    return result
}
