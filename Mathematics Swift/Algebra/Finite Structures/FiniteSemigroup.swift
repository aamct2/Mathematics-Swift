//
//  FiniteSemigroup.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/11/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class FiniteSemigroup<T: protocol<Equatable, Initable>> : FiniteMagma<T> {
    
    var semigroupProperties = [String: Bool]()
    
    // MARK: - Constructors
    
    /**
    *  Creates a new finite semigroup.
    *
    *  @param mySet The set for the semigroup.
    *  @param operation The operation for the semigroup.
    */
    init(mySet: FiniteSet<T>, operation: FiniteBinaryOperation<T>) {
        super.init(mySet: mySet, operation: operation)
        
        assert(operation.isAssociative(), "The new operation is not associative.")
    }
    
    // MARK: - Methods
    
    /**
    *  Returns whether or not the semigroup is also a band (a semigroup that is idempotent)
    *
    *  @return Returns **true** if the semigroup is also a band, **false** otherwise.
    */
    func isBand() -> Bool {
        if !(contains(semigroupProperties.keys, "band")) {
            semigroupProperties["band"] = operation.isIdempotent()
        }
        
        return semigroupProperties["band"]!
    }
    
    /**
    *  Determines whether a given finite set and operation will form a finite semigroup.
    *
    *  @param testSet The finite set to test.
    *  @param testOperation The operation to test.
    *
    *  @return Returns **true** if the given set and operation will form a semigroup, **false** otherwise.
    */
    class func isSemigroup(testSet: FiniteSet<T>, testOperation: FiniteBinaryOperation<T>) -> Bool {
        return FiniteMagma.isMagma(testSet, testOperation: testOperation) && testOperation.isCommutative()
    }
    
    /**
    *  Determines whether a given finite magma will form a finite semigroup.
    *
    *  @param testMagma The magma to test.
    *
    *  @return Returns **true** if the given magma is also a semigroup, **false** otherwise.
    */
    class func isSemigroup(testMagma: FiniteMagma<T>) -> Bool {
        return testMagma.operation.isCommutative()
    }
    
    /**
    *  Returns whether or not the semigroup is also a semilattice (a semigroup that is both a band and commutative)
    *
    *  @return Returns **true** if the semigroup is also a semilattice, **false** otherwise.
    */
    func isSemilattice() -> Bool {
        if !(contains(semigroupProperties.keys, "semilattice")) {
            semigroupProperties["semilattice"] = self.isBand() && operation.isCommutative()
        }
        
        return semigroupProperties["semilattice"]!
    }
    
}
