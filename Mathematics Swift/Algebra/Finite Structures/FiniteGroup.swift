//
//  FiniteGroup.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/12/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class FiniteGroup<T: protocol<Equatable, Initable>> : FiniteMonoid<T>, Equatable, Initable {
    
    var allSubgroups: FiniteSet<FiniteGroup<T>>?
    var allNormalSubgroups: FiniteSet<FiniteGroup<T>>?
    
    var groupProperties = [String: Bool]()
    
    // MARK: - Constructors
    
    /**
    *  Initializes the trivial group of type T.
    */
    convenience init() {
        var newSet = FiniteSet<T>()
        newSet.addElement(T())
        
        var pairSet = FiniteSet<OrderedPair<Tuple, T>>()
        var pairTup = Tuple(elements: [T(), T()])
        pairSet.addElement(OrderedPair<Tuple, T>(x: pairTup, y: T()))
        
        var newRelation = SetDefinedMap<Tuple, T>(relation: pairSet)
        
        var newOperation = FiniteBinaryOperation(codomain: newSet, relation: newRelation)
        
        self.init(mySet: newSet, operation: newOperation)
    }
    
    /**
    *  Creates a new finite group.
    *
    *  @param mySet The set for the group.
    *  @param operation The operation for the group.
    */
    init(mySet: FiniteSet<T>, operation: FiniteBinaryOperation<T>) {
        super.init(mySet: mySet, operation: operation)
        
        assert(operation.hasInverses(), "The new operation does not have inverses for every element.")
    }
    
    /**
    *  Creates a new finite group and stores any initially known properties of the group.
    *
    *  @param mySet The set for the group.
    *  @param operation The operation for the group.
    *  @param knownProperties Any known properties about the group already.
    */
    convenience init(mySet: FiniteSet<T>, operation: FiniteBinaryOperation<T>, knownProperties: [String: Bool]) {
        
        self.init(mySet: mySet, operation: operation)
        
        for (key, value) in knownProperties {
            if contains(self.groupProperties.keys, key) == false {
                groupProperties.updateValue(value, forKey: key)
            }
        }
    }
    
    // MARK: - Methods
    
    /**
    *  Returns the center of the group as a set. In other words, the set of all elements that commute with every other element in the group.
    *
    *  @return The center of the group as a set.
    */
    func center() -> FiniteSet<T> {
        var newSet = FiniteSet<T>()
        
        for index1 in 0 ..< self.order() {
            var inCenter = true
            
            searchCenter: for index2 in 0 ..< self.order() {
                if !(commutator(mySet[index1], rhs: mySet[index2]) == self.identity) {
                    inCenter = false
                    break searchCenter
                }
            }
            
            if inCenter == true {
                newSet.addElement(mySet[index1])
            }
        }
        
        return newSet
    }
    
    /**
    *  Returns the center of the group as a group. (In fact, this group is always abelian.)
    *
    *  @return Returns the center of the group as a group.
    */
    func centerGroup() -> FiniteGroup<T> {
        var knownProperties = self.subgroupClosedProperties()
        var newSet = self.center()
        
        knownProperties["abelian"] = true
        
        var newOp = self.operation.restriction(newSet)
        
        return FiniteGroup<T>(mySet: newSet, operation: newOp, knownProperties: knownProperties)
    }
    
    /**
    *  Returns the conjugacy class of an element.
    *
    *  @param elem The element whose conjugacy class is to be returned.
    *
    *  @return The conjugacy class of an element as a **FiniteSet**.
    */
    func conjugacyClass(elem: T) -> FiniteSet<T> {
        assert(contains(mySet.elements, elem), "The parameter 'elem' is not an element of this group.")
        
        var newSet = FiniteSet<T>()
        
        for index in 0 ..< mySet.cardinality() {
            var tup1 = Tuple(size: 2)
            var tup2 = Tuple(size: 2)
            
            tup1.elements[0] = mySet[index]
            tup1.elements[1] = elem
            tup2.elements[0] = applyOperation(tup1)
            tup2.elements[1] = operation.inverseElement(mySet[index])!
            
            newSet.addElement(applyOperation(tup2))
        }
        
        return newSet
    }
    
    /**
    *  Returns the commutator of two elements, in a sense given an indication of how badly the operation fails to commute for two elements. [g,h] = g^-1 + h^-1 + g + h.
    *
    *  @param lhs The first element.
    *  @param rhs The second element.
    *
    *  @return The commutator of two elements.
    */
    func commutator(lhs: T, rhs: T) -> T {
        var tup1 = Tuple(size: 2)
        var tup2 = Tuple(size: 2)
        var tup3 = Tuple(size: 2)
        
        assert(contains(self.mySet.elements, lhs) && contains(self.mySet.elements, rhs), "The parameter 'lhs' or 'rhs' is not a member of the group.")
        
        tup1.elements[0] = self.operation.inverseElement(lhs)!
        tup1.elements[1] = self.operation.inverseElement(rhs)!
        tup2.elements[0] = self.operation.applyMap(tup1)
        tup2.elements[1] = lhs
        tup3.elements[0] = self.operation.applyMap(tup2)
        tup3.elements[1] = rhs
        
        return self.applyOperation(tup3)
    }
    
    /**
    *  Determines whether this group is a subgroup of another group.
    *
    *  @param superGroup The supergroup (or ambient group) to test if this group is a subgroup of it.
    *
    *  @return Returns **true** if the group is a subgroup of a given group, **false** otherwise.
    */
    func isSubgroupOf(superGroup: FiniteGroup<T>) -> Bool {
        if mySet.isSubsetOf(superGroup.mySet) == false { return false }
        
        if self.operation.equivalentMaps(superGroup.operation.relation, testDomain: superGroup.operation.domain, testCodomain: superGroup.operation.codomain) == false { return false }
        
        // Collect any useful new inherited information since it is a subgroup.
        for (key, value) in superGroup.subgroupClosedProperties() {
            if contains(groupProperties.keys, key) == false {
                groupProperties[key] = value
            }
        }
        
        return true
    }
    
    /**
    *  Returns the order of the group.
    *
    *  @return The order of the group.
    */
    func order() -> Int {
        return self.mySet.cardinality()
    }
    
    func order(elem: T) -> Int {
        assert(contains(mySet.elements, elem), "The parameter 'elem' is not a member of the group.")
        
        // if self.order() > 5
        
        // Deal with the trivial case
        if elem == self.identity {
            return 1
        }
        
        // The order of an element must divide the order of the group, thus we only need to check those powers
        var possibleOrders: [Int]
        var curPwr: T
        
        // Initialize the current power of the element
        curPwr = elem
        
        // Find all possible values for the order of the element
        possibleOrders = findFactors(self.order())
        
        for index in 1 ..< possibleOrders.count {
            var curTup = Tuple(size: 2)
            curTup.elements[0] = curPwr
            curTup.elements[1] = self.power(elem, exponent: possibleOrders[index] - possibleOrders[index - 1])
            curPwr = self.applyOperation(curTup)
            
            if curPwr == self.identity {
                return possibleOrders[index]
            }
        }
        
        fatalError("Error: Could not find order of element?! There must be a problem with the code.")
    }
    
    /**
    *  Returns the power of a given element.
    *
    *  @param elem The element to multiply by itself to the exponent-th degree.
    *  @param exponent The number of times to multiply the element by itself.
    *
    *  @return The power of a given element.
    */
    func power(elem: T, exponent: Int) -> T {
        var x: T
        var g: T
        var curTup = Tuple(size: 2)
        var curExponent = exponent
        
        x = self.identity
        g = elem
        
        if curExponent % 2 == 1 {
            curTup.elements[0] = x
            curTup.elements[1] = g
            x = self.applyOperation(curTup)
        }
        
        while curExponent > 1 {
            curTup.elements[0] = g
            curTup.elements[1] = g
            g = self.applyOperation(curTup)
            
            curExponent = curExponent / 2
            
            if curExponent % 2 == 1 {
                curTup.elements[0] = x
                curTup.elements[1] = g
                x = self.applyOperation(curTup)
            }
        }
        
        return x
    }
    
    /**
    *  Returns the set of all conjugacy classes of this group.
    *
    *  @return The set of all conjugacy classes of this group.
    */
    func setOfAllConjugacyClasses() -> FiniteSet<FiniteSet<T>> {
        var newSet = FiniteSet<FiniteSet<T>>()
        
        for index in 0 ..< mySet.cardinality() {
            newSet.addElement(self.conjugacyClass(mySet[index]))
        }
        
        return newSet
    }
    
    /**
    *  Returns the trivial subgroup of this group.
    *
    *  @return The trivial subgroup of this group.
    */
    func trivialSubgroup() -> FiniteGroup<T> {
        var newSet = FiniteSet<T>()
        newSet.addElement(self.identity)
        
        var newOp = self.operation.restriction(newSet)
        
        return FiniteGroup<T>(mySet: newSet, operation: newOp, knownProperties: subgroupClosedProperties())
    }
    
    // MARK: - Properties Subsets
    
    func subgroupClosedProperties() -> [String: Bool] {
        return propertiesSubset(["abelian", "cyclic", "dedekind", "metabelian", "metanilpotent", "nilpotent", "solvable", "t*-group"], superSet: groupProperties)
    }
    
    func quotientClosedProperties() -> [String: Bool] {
        return propertiesSubset(["abelian", "ambivalent", "cyclic", "dedekind", "metabelian", "metanilpotent", "nilpotent", "perfect", "solvable", "t*-group"], superSet: groupProperties)
    }
    
    func productClosedProperties() -> [String: Bool] {
        // Taken from: http://groupprops.subwiki.org/wiki/Cyclic_group
        // A direct product of cyclic groups need not be cyclic.
        // It is cyclic if and only if the two groups have relatively prime orders
        // TODO: Implement this test
        
        return propertiesSubset(["abelian", "ambivalent", "metabelian", "nilpotent", "perfect", "solvable"], superSet: groupProperties)
    }
    
}

func == <T: protocol<Equatable, Initable>> (lhs: FiniteGroup<T>, rhs: FiniteGroup<T>) -> Bool {
    return lhs.mySet == rhs.mySet && lhs.operation == rhs.operation
}
