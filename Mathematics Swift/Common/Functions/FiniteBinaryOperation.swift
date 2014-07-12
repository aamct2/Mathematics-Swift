//
//  FiniteBinaryOperation.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/8/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class FiniteLeftExternalBinaryOperation<LeftOperand: protocol<Equatable, Initable>, RightOperand: protocol<Equatable, Initable>> : FiniteFunction<Tuple, RightOperand> {
    
    var myLeftIdentity = LeftOperand()
    
    var leftIdentity : LeftOperand? {
        if !(contains(functionProperties.keys, "left identity")) {
            // First check to see if there is one and generate it along the way.
            self.hasLeftIdentity()
        }
            
        if functionProperties["left identity"] == false {
            //There is no left identity element for this operation.
            return nil
        } else {
            return myLeftIdentity
        }
    }
    
    var leftOperandDomain = FiniteSet<LeftOperand>()
    var rightOperandDomain = FiniteSet<RightOperand>()
    
    // MARK: - Constructors
    
    init(scalarSet: FiniteSet<LeftOperand>, codomain: FiniteSet<RightOperand>, relation: MathMap<Tuple, RightOperand>) {
        super.init(domain: scalarSet.directProduct(codomain), codomain: codomain, relation: relation)
        
        leftOperandDomain = scalarSet
        rightOperandDomain = codomain
    }
    
    // MARK: - Methods
    
    func hasLeftIdentity() -> Bool {
        if !(contains(functionProperties.keys, "left identity")) {
            for index1 in 0..<self.leftOperandDomain.cardinality() {
                var curLeft = leftOperandDomain[index1]
                var same = true
                
                searchRightOperandDomain: for index2 in 0..<self.rightOperandDomain.cardinality() {
                    var curRight = rightOperandDomain[index2]
                    
                    var curTup = Tuple(size: 2)
                    
                    curTup.elements[0] = curLeft
                    curTup.elements[1] = curRight
                    if same == true && !(curRight == self.applyMap(curTup)) {
                        same = false
                        break searchRightOperandDomain
                    }
                }
                
                if same == true {
                    // We found the identity element!
                    functionProperties.updateValue(true, forKey: "left identity")
                    myLeftIdentity = curLeft
                    return true
                }
            }
            
            // There is no identity element for this operation
            functionProperties.updateValue(false, forKey: "left identity")
            return false
        }
        
        return functionProperties["left identity"]!
    }
    
}

class FiniteBinaryOperation<T: protocol<Equatable, Initable>> : FiniteFunction<Tuple, T> {
    
    var identityElement: T?
    var myCayleyTable = [[Int]]()
    
    var identity : T? {
        if contains(functionProperties.keys, "identity") == false {
            // First check to see if there is one and generate it along the way
            self.hasIdentity()
        }
        
        if functionProperties["identity"] == false {
            return nil
        } else {
            return identityElement!
        }
    }
    
    // MARK: - Constructors
    
    /**
    *  Creates a new binary operation.
    */
    init(codomain: FiniteSet<T>, relation: MathMap<Tuple, T>) {
        super.init(domain: codomain.directProduct(codomain), codomain: codomain, relation: relation)
    }
    
    init(codomain: FiniteSet<T>, relation: MathMap<Tuple, T>, knownProperties: Dictionary<String, Bool>) {
        super.init(domain: codomain.directProduct(codomain), codomain: codomain, relation: relation)
        
        for (key, value) in knownProperties {
            if contains(self.functionProperties.keys, key) == false {
                functionProperties.updateValue(value, forKey: key)
            }
        }
    }
    
    // MARK: - Methods
    
    func cayleyTableGeneric() -> [[Int]] {
        if contains(functionProperties.keys, "cayley table") {
            return myCayleyTable
        }
        
        let domainSize = codomain.cardinality()
        
        var result = [[Int]]()
        
        for rowIndex in 0 ..< domainSize {
            for columnIndex in 0 ..< domainSize {
                var tup = Tuple(size: 2)
                
                tup.elements[0] = codomain[rowIndex]
                tup.elements[1] = codomain[columnIndex]
                
                result[rowIndex][columnIndex] = codomain.indexOf(relation.applyMap(tup))
            }
        }
        
        functionProperties["cayley table"] = true
        myCayleyTable = result
        
        return result
    }
    
    /**
    *  Returns the inverse of the element. In other words, given a this function returns b such that a + b = b + a = e.
    *
    *  @param elem Element for which to find the inverse.
    *
    *  @return The inverse of **elem**.
    */
    func inverseElement(elem: T) -> T? {
        assert(self.hasIdentity(), "This operation does not have an identity element.")
        
        for index in 0 ..< codomain.cardinality() {
            var tup1 = Tuple(size: 2)
            var tup2 = Tuple(size: 2)
            
            tup1.elements[0] = elem
            tup1.elements[1] = codomain[index]
            tup2.elements[0] = codomain[index]
            tup2.elements[1] = elem
            
            if self.applyMap(tup1) == self.identity && self.applyMap(tup2) == self.identity {
                return codomain[index]
            }
        }
        
        // This element does not have an inverse.
        return nil
    }
    
    func isAssociative() -> Bool {
        if contains(functionProperties.keys, "associativity") {
            return functionProperties["associativity"]!
        }
        
        let domainSize = codomain.cardinality()
        
        // TODO: Finish
        
        var originalTable = self.cayleyTableGeneric()
        var cayleyMatrix = SquareMatrix<RealNumber>(rows: domainSize + 1)
        
        // Turn the Cayley table into a SquareMatrix for easier processing
        for colIndex in 0 ..< domainSize {
            cayleyMatrix[0, colIndex] = RealNumber(value: Double(colIndex))
        }
        for rowIndex in 0 ..< domainSize {
            for colIndex in 0 ... domainSize {
                cayleyMatrix[rowIndex + 1, colIndex] = RealNumber(value: Double(originalTable[rowIndex][colIndex]))
            }
        }
        
        for keyElementIndex in 0 ..< domainSize {
            // Build header for lightTable
        }
        
        return false
    }
    
    func isCommutative() -> Bool {
        if contains(functionProperties.keys, "commutivity") {
            return functionProperties["commutivity"]!
        }
        
        let domainSize = codomain.cardinality()
        
        for index1 in 0 ..< domainSize {
            for index2 in 0 ..< domainSize {
                var tup1 = Tuple(size: 2)
                
                // TODO: Finish
            }
        }
        
        return false
    }
    
    func isIdempotent() -> Bool {
        if contains(functionProperties.keys, "idempotent") {
            return functionProperties["idempotent"]!
        }
        
        for index in 0 ..< codomain.cardinality() {
            var tup = Tuple(size: 2)
            
            tup.elements[0] = codomain[index]
            tup.elements[1] = codomain[index]
            
            if !(applyMap(tup) == codomain[index]) {
                functionProperties["idempotent"] = false
                return false
            }
        }
        
        functionProperties["idempotent"] = true
        return true
    }
    
    /**
    *  Determines if the operation has an identity element. In other words there exists an e such that for all a, a + e = e + a = a.
    *
    *  @return Whether or not the operation has an identity element.
    */
    func hasIdentity() -> Bool {
        if contains(functionProperties.keys, "identity") {
            return functionProperties["identity"]!
        }
        
        for index1 in 0 ..< codomain.cardinality() {
            var curT = codomain[index1]
            var same = true
            
            for index2 in 0 ..< codomain.cardinality() {
                var otherT = codomain[index2]
                
                var curTup = Tuple(size: 2)
                
                curTup.elements[0] = curT
                curTup.elements[1] = otherT
                if same == true && !(otherT == applyMap(curTup)) {
                    same = false
                }
                
                curTup.elements[0] = otherT
                curTup.elements[1] = curT
                if same == true && !(otherT == applyMap(curTup)) {
                    same = false
                }
            }
            
            if same == true {
                // We found the identity element!
                
                functionProperties["identity"] = true
                identityElement = curT
                
                return true
            }
        }
        
        // There is no identity element for this operation
        functionProperties["identity"] = false
        
        return false
    }
    
    func hasInverses() -> Bool {
        // TODO: Finish
        
        return false
    }
    
    func restriction(newCodomain: FiniteSet<T>) -> FiniteBinaryOperation<T> {
        assert(newCodomain.isSubsetOf(self.codomain), "The newCodomain is not a subset of this operation's Codomain.")
        
        var newOp = FiniteBinaryOperation<T>(codomain: newCodomain, relation: self.relation)
        
        // TODO: Finish
        
        return newOp
    }
    
}
