//
//  FiniteFunction.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/8/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class FiniteFunction<T: protocol<Equatable, Initable>, G: protocol<Equatable, Initable>> : Equatable {
    
    var domain = FiniteSet<T>()
    var codomain = FiniteSet<G>()
    var relation = MathMap<T, G>()
    var functionProperties = [String: Bool]()
    var image: FiniteSet<G>?
    var inverse: FiniteFunction<G, T>?
    
    // MARK: - Constructors
    
    init(domain: FiniteSet<T>, codomain: FiniteSet<G>, relation: MathMap<T, G>) {
        self.domain = domain
        self.codomain = codomain
        
        for index in 0..<self.domain.cardinality() {
            if contains(self.codomain.elements, relation.applyMap(self.domain[index])) == false {
                fatalError("The codomain does not contain the output element for the domain element.")
            }
        }
        
        self.relation = relation
    }
    
    // MARK: - Methods
    
    func applyMap(input: T) -> G {
        if contains(domain.elements, input) == false {
            fatalError("Domain does not contain input element!")
        }
        
        // No need to check if the output is in the codomain.
        // The relation is checked to be well-defined when the relation is set.
        
        return relation.applyMap(input)
    }
    
    /**
    *  Returns a composition of function in which this function is the outer function of the composition.
    *
    *  @param innerFunction
    *
    *  @return Composition of function in which this function is the outer function of the composition.
    */
    func composition<S: protocol<Equatable, Initable>>(innerFunction: FiniteFunction<S, T>) -> FiniteFunction<S, G> {
        if !(innerFunction.codomain == self.domain) {
            fatalError("The codomain of innerFunction must be equal to the domain of this function.")
        }
        
        var newMap = CompositionMap<S, T, G>(innerMap: innerFunction.relation, outerMap: self.relation)
        var newFunc = FiniteFunction<S, G>(domain: innerFunction.domain, codomain: self.codomain, relation: newMap)
        
        if contains(self.functionProperties.keys, "injective") && contains(innerFunction.functionProperties.keys, "injective") {
            if self.isInjective() && innerFunction.isInjective() {
                newFunc.functionProperties.updateValue(true, forKey: "injective")
            }
        }
        
        if contains(self.functionProperties.keys, "surjective") && contains(innerFunction.functionProperties.keys, "surjective") {
            if self.isSurjective() && innerFunction.isSurjective() {
                newFunc.functionProperties.updateValue(true, forKey: "surjective")
            }
        }
        
        if contains(self.functionProperties.keys, "bijective") && contains(innerFunction.functionProperties.keys, "bijective") {
            if self.isBijective() && innerFunction.isBijective() {
                newFunc.functionProperties.updateValue(true, forKey: "bijective")
            }
        }
        
        return newFunc
    }
    
    func equals(otherFunction: FiniteFunction<T, G>) -> Bool {
        if !(otherFunction.domain == self.domain) || !(otherFunction.codomain == self.codomain) {
            return false
        }
        
        for index in 0..<self.domain.cardinality() {
            if !(self.applyMap(self.domain[index]) == otherFunction.applyMap(self.domain[index])) {
                return false
            }
        }
        
        return true
    }
    
    func equivalentMaps(otherMap: MathMap<T, G>, testDomain: FiniteSet<T>, testCodomain: FiniteSet<G>) -> Bool {
        
        // TODO: Finish
        
        return false
    }
    
    /**
    *  Returns the image of the function.
    */
    func imageSet() -> FiniteSet<G> {
        if let myImage = image {
            return myImage
        } else {
            var imgSet = FiniteSet<G>()
            
            for domIndex in 0..<self.domain.cardinality() {
                imgSet.elements += self.applyMap(self.domain[domIndex])
            }
            
            image = imgSet
            
            return imgSet
        }
    }
    
    /**
    *  Returns the inverse image of a set.
    *
    *  @param resultSet The sets of elements who inverse image is desired.
    *
    *  @return Inverse image of a set.
    */
    func inverseImageSet(resultSet: FiniteSet<G>) -> FiniteSet<T> {
        var invImgSet = FiniteSet<T>()
        
        for resultSetIndex in 0..<resultSet.cardinality() {
            var curResult = resultSet[resultSetIndex]
            
            // TODO: Could be optimized
            for domIndex in 0..<self.domain.cardinality() {
                if self.applyMap(self.domain[domIndex]) == curResult {
                    invImgSet.elements += self.domain[domIndex]
                }
            } // End For domIndex
        } // End For resultSetIndex
        
        return invImgSet
    }
    
    /**
    *  Returns the inverse of this function if it exists.
    *
    *  @return Inverse of this function if it exists
    */
    func inverseFunction() -> FiniteFunction<G, T>? {
        if let myInverse = inverse {
            return myInverse
        } else {
            if self.isBijective() == false {
                // Undefined Error: This function is not bijective and therefore an inverse function does not exist.
                
                return nil
            }
            
            var inverseRelation = FiniteSet<OrderedPair<G, T>>()
            
            for index in 0..<self.domain.cardinality() {
                var input = self.domain[index]
                
                inverseRelation.elements += OrderedPair<G, T>(x: self.applyMap(input), y: input)
            } // End For index
            
            var inverseMap = SetDefinedMap<G, T>(relation: inverseRelation)
            var inverseFunc = FiniteFunction<G, T>(domain: self.codomain, codomain: self.domain, relation: inverseMap)
            
            inverse = inverseFunc
            
            return inverseFunc
        }
    }
    
    func isInjective() -> Bool {
        if !(contains(functionProperties.keys, "injective")) {
            for index1 in 0..<self.domain.cardinality() {
                for index2 in 0..<self.domain.cardinality() {
                    if index1 != index2 {
                        if self.applyMap(self.domain[index1]) == self.applyMap(self.domain[index2]) {
                            functionProperties.updateValue(false, forKey: "injective")
                            return false
                        }
                    }
                } // End For index2
            } // End For index1
            
            functionProperties.updateValue(true, forKey: "injective")
            return true
        }
        
        return functionProperties["injective"]!
    }
    
    func isSurjective() -> Bool {
        if !(contains(functionProperties.keys, "surjective")) {
            for codomIndex in 0..<self.codomain.cardinality() {
                var found = false
                
                searchCodomain: for domIndex in 0..<self.domain.cardinality() {
                    if self.applyMap(self.domain[domIndex]) == self.codomain[codomIndex] {
                        found = true
                        break searchCodomain
                    }
                } // End For domIndex
                
                if found == false {
                    functionProperties.updateValue(false, forKey: "surjective")
                    return false
                }
            } // End For codomIndex
            
            functionProperties.updateValue(true, forKey: "surjective")
            return true
        }
        
        return functionProperties["surjective"]!
    }
    
    func isBijective() -> Bool {
        if !(contains(functionProperties.keys, "bijective")) {
            if self.isInjective() && self.isSurjective() {
                functionProperties.updateValue(true, forKey: "bijective")
                return true
            } else {
                functionProperties.updateValue(false, forKey: "bijective")
                return false
            }
        }
        
        return functionProperties["bijective"]!
    }
    
    func restriction(newDomain: FiniteSet<T>) -> FiniteFunction<T, G>? {
        if newDomain.isSubsetOf(self.domain) == false {
            // The newDomain is not a subset of this function's Domain.
            return nil
        }
        
        var newFunc = FiniteFunction<T, G>(domain: newDomain, codomain: self.codomain, relation: self.relation)
        
        // Injectivity is inherited by restriction
        if contains(functionProperties.keys, "injective") {
            if functionProperties["injective"] == true {
                newFunc.functionProperties.updateValue(true, forKey: "injective")
            }
        }
        
        return newFunc
    }
    
}

func == <T: protocol<Equatable, Initable>, G: protocol<Equatable, Initable>> (lhs: FiniteFunction<T, G>, rhs: FiniteFunction<T, G>) -> Bool {
    return lhs.equals(rhs)
}
