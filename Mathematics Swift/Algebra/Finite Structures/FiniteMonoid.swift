//
//  FiniteMonoid.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/11/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class FiniteMonoid<T: protocol<Equatable, Initable>> : FiniteSemigroup<T> {
    var identity = T()
    
    // MARK: - Constructors
    
    /**
    *  Creates a new finite monoid.
    *
    *  @param mySet The set for the monoid.
    *  @param operation The operation for the monoid.
    */
    init(mySet: FiniteSet<T>, operation: FiniteBinaryOperation<T>) {
        super.init(mySet: mySet, operation: operation)
        
        assert(operation.hasIdentity(), "The new operation does not have an identity element.")
        
        self.identity = operation.identity!
    }
    
    // MARK: - Methods
    
    /**
    *  Determines whether a function is a homomorphism from this monoid to another monoid.
    *
    *  @param codomain The other monoid that serves as the codomain for the function.
    *  @param testFunction The function to test.
    *
    *  @return Returns **true** if the function is a homomorphism between the monoids, **false** otherwise.
    */
    func isHomomorphism<G: protocol<Equatable, Initable>>(codomain: FiniteMonoid<G>, testFunction: FiniteFunction<T, G>) -> Bool {
        
        assert(testFunction.codomain == codomain.mySet, "The codomain of of the parameter 'testFunction' is not the parameter 'codomain'.")
        assert(testFunction.domain == self.mySet, "The domain of of the parameter 'testFunction' is not this monoid.")
        
        // Check that f(a + b) = f(a) * f(b)
        for index1 in 0 ..< self.mySet.cardinality() {
            for index2 in 0 ..< self.mySet.cardinality() {
                var tup1 = Tuple(size: 2)
                tup1.elements[0] = self.mySet[index1]
                tup1.elements[1] = self.mySet[index2]
                var lhs = testFunction.applyMap(self.applyOperation(tup1)!)!
                
                var tup2 = Tuple(size: 2)
                tup2.elements[0] = testFunction.applyMap(self.mySet[index1])!
                tup2.elements[1] = testFunction.applyMap(self.mySet[index2])!
                var rhs = testFunction.applyMap(self.applyOperation(tup2)!)!
                
                if !(lhs == rhs) {
                    return false
                }
            } // End For index2
        } // End For index1
        
        // Check that f(1) = 1
        if !(testFunction.applyMap(self.identity) == codomain.identity) {
            return false
        }
        
        return true
    }
    
    /**
    *  Determines whether a function is a isomorphism from this monoid to another monoid. In other words, it's a bijective homomorphism.
    *
    *  @param codomain The other monoid that serves as the codomain for the function.
    *  @param testFunction The function to test.
    *
    *  @return Returns **true** if the function is an isomorphism between the monoids, **false** otherwise.
    */
    func isIsomorphism<G: protocol<Equatable, Initable>>(codomain: FiniteMonoid<G>, testFunction: FiniteFunction<T, G>) -> Bool {
        
        assert(testFunction.codomain == codomain.mySet, "The codomain of of the parameter 'testFunction' is not the parameter 'codomain'.")
        assert(testFunction.domain == self.mySet, "The domain of of the parameter 'testFunction' is not this group.")
        
        if testFunction.isBijective() && self.isHomomorphism(codomain, testFunction: testFunction) {
            return true
        } else {
            return false
        }
    }
    
    /**
    *  Determines whether a given finite set and operation will form a finite monoid.
    *
    *  @param testSet The finite set to test.
    *  @param testOperation The operation to test.
    *
    *  @return Return **true** if the given set and operation form a monoid, **false** otherwise.
    */
    class func isMonoid(testSet: FiniteSet<T>, testOperation: FiniteBinaryOperation<T>) -> Bool {
        return FiniteSemigroup.isSemigroup(testSet, testOperation: testOperation) && testOperation.hasIdentity()
    }
    
    /**
    *  Determines whether a given finite semigroup will form a finite monoid.
    *
    *  @param testSemigroup The semigroup to test.
    *
    *  @return Returns **true** if the given semigroup is also a monoid, **false** otherwise.
    */
    class func isMonoid(testSemigroup: FiniteSemigroup<T>) -> Bool {
        return testSemigroup.operation.hasIdentity()
    }
    
}
