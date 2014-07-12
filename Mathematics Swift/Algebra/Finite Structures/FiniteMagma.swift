//
//  FiniteMagma.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/10/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class FiniteMagma<T: protocol<Equatable, Initable>> {
    var mySet = FiniteSet<T>()
    var operation: FiniteBinaryOperation<T>
    var magmaProperties = [String: Bool]()
    var allSquareElements = FiniteSet<T>()
    
    // MARK: - Constructors
    
    init(mySet: FiniteSet<T>, operation: FiniteBinaryOperation<T>) {
        self.mySet = mySet
        
        // Only need to check that the set equals the codomain of the operation.
        // Domain of the operation, by construction of FiniteBinaryOperation, will be (codomain X codomain)
        assert(operation.codomain == mySet, "The codomain of the new operation is not the set of the magma.")
        
        self.operation = operation
    }
    
    // MARK: - Functions
    
    /**
    *  Returns the result of applying the operation of the structure to a Tuple (pair) of elements.
    *
    *  @param input The Tuple (pair) to apply the operation to.
    *
    *  @return The output of the operation applied to the given input.
    */
    func applyOperation(input: Tuple) -> T? {
        return operation.applyMap(input)
    }
    
    /**
    *  Determines whether a given finite set and operation will form a finite magma.
    *
    *  @param testSet The finite set to test.
    *  @param testOperation The operation to test.
    *
    *  @return Returns **true** if the given set and operation will form a magma, **false** otherwise.
    */
    class func isMagma(testSet: FiniteSet<T>, testOperation: FiniteBinaryOperation<T>) -> Bool {
        return testOperation.codomain == testSet
    }
    
    /**
    *  Returns the set of all elements of the structure 'a' such that there exists a 'b' where 'a' = 'b' * 'b'.
    *
    *  @return The finite set of all square elements.
    */
    func setOfSquareElements() -> FiniteSet<T> {
        if contains(magmaProperties.keys, "all square elements") == false {
            var result = FiniteSet<T>()
            
            for index in 0 ..< mySet.cardinality() {
                let curElem = mySet.elements[index]
                
                var curTup = Tuple(size: 2)
                
                curTup.elements[0] = curElem
                curTup.elements[1] = curElem
                
                result.elements += self.operation.applyMap(curTup)!
            }
            
            allSquareElements = result
            magmaProperties["all square elements"] = true
        }
        
        return allSquareElements.clone()
    }
    
    
}
