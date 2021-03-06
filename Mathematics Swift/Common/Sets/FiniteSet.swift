//
//  FiniteSet.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/7/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

public class FiniteSet<T : protocol<Equatable, Initable>> : Equatable, Initable, ISubtractable, Sequence {
    
    // MARK: - Properties
    
    private var elements = [T]()
    
    public var additiveIdentity : FiniteSet<T> {
        return FiniteSet<T>()
    }
    
    class var nullSet : FiniteSet<T> {
        return FiniteSet<T>()
    }
    
    // MARK: - Constructors
    
    public init() {}
    
    public init(elements: [T]) {
        self.elements = elements
    }
    
    // MARK: - Methods
    
    /**
    *  Returns the union of this set with another set.
    *
    *  @param rhs
    *
    *  @return Union of this set with another set.
    */
    public func add(rhs: FiniteSet<T>) -> FiniteSet<T> {
        var newSet = FiniteSet<T>()
        
        // Don't waste time cranking the intersection if one of the sets is null
        if cardinality() == 0 {
            return rhs.clone()
        } else if rhs.cardinality() == 0 {
            return clone()
        }
        
        for index in 0 ..< cardinality() {
            newSet.addElement(elements[index])
        }
        
        for index in 0 ..< rhs.cardinality() {
            newSet.addElement(rhs.elements[index])
        }
        
        return newSet
    }
    
    /**
    *  Adds an element to this set.
    *
    *  @param newElement
    */
    public func addElement(newElement: T) {
        for element in elements {
            if element == newElement { return }
        }
        
        elements += newElement
    }
    
    /**
    *  Adds an element to this set, without checking to see if it's already in the set
    *
    *  @param newElement
    */
    public func addElementWithoutCheck(newElement: T) {
        elements += newElement
    }
    
    /**
    *  Returns the number of elements in this set.
    *
    *  @return Number of elements in this set.
    */
    public func cardinality() -> Int {
        return elements.count
    }
    
    public func clone() -> FiniteSet<T> {
        // TODO: Finish
        
        return FiniteSet<T>()
    }
    
    public func containsElement(element: T) -> Bool {
        return contains(self.elements, element)
    }
    
    /**
    *  Deletes an elements from this set.
    *
    *  @param index Index of the element to be deleted.
    */
    public func deleteElement(index: Int) {
        assert(index <= elements.count - 1, "Index out of range.")
        
        elements.removeAtIndex(index)
    }
    
    /**
    *  Returns the set-theoretic difference of this set minus the other set.
    *
    *  @param otherSet
    *
    *  @return Difference of this set minus the other set.
    */
    public func difference(otherSet: FiniteSet<T>) -> FiniteSet<T> {
        return self.subtract(otherSet)
    }
    
    /**
    *  Returns the direct product (also known as the cartesian product) of this set and another set.
    *
    *  @param otherSet
    *
    *  @return Direct product of this set and another set.
    */
    public func directProduct<G: protocol<Equatable, Initable>>(otherSet: FiniteSet<G>) -> FiniteSet<Tuple> {
        
        var newSet = FiniteSet<Tuple>()
        
        // By convention, anything direct product the null set is the null set
        // For all sets A: A x {} = {}
        if self.cardinality() == 0 || otherSet.cardinality() == 0 {
            return newSet
        }
        
        for lIndex in 0 ..< self.cardinality() {
            var leftElement = self.elements[lIndex]
            
            for rIndex in 0 ..< otherSet.cardinality() {
                var curPair = Tuple(size: 2)
                
                curPair.elements[0] = leftElement
                curPair.elements[1] = otherSet.elements[rIndex]
                
                newSet.elements += curPair
            }
        }
        
        return newSet
    }
    
    /**
    *  Determines whether this set is equal to another set.
    *
    *  @param otherSet
    *
    *  @return Whether this set is equal to another set.
    */
    public func equals(otherSet: FiniteSet<T>) -> Bool {
        if cardinality() != otherSet.cardinality() { return false }
        
        for lIndex in 0 ..< cardinality() {
            var found = false
            
            searchRHS: for rIndex in 0 ..< cardinality() {
                if elements[lIndex] == otherSet.elements[lIndex] {
                    found = true
                    break searchRHS
                }
            }
            
            if found == false { return false }
        }
        
        return true
    }
    
    /**
    *  Returns the index of 'element' in the set.
    *
    *  @param element
    *
    *  @return Index of 'element' in the set or -1 if the element is not found.
    */
    public func indexOf(element: T) -> Int {
        for index in 0 ..< cardinality() {
            if elements[index] == element { return index }
        }
        
        return -1
    }
    
    /**
    *  Returns the intersection of this set with another set.
    *
    *  @param otherSet
    *
    *  @return Intersection of this set with another set.
    */
    public func intersection(otherSet: FiniteSet<T>) -> FiniteSet<T> {
        var newSet = FiniteSet<T>()
        
        // Don't waste time cranking the intersection if one of the sets is the null set
        if self.cardinality() == 0 || otherSet.cardinality() == 0 { return newSet }
        
        for lIndex in 0 ..< self.cardinality() {
            searchRHS: for rIndex in 0 ..< otherSet.cardinality() {
                if self.elements[lIndex] == otherSet.elements[rIndex] {
                    newSet.elements += self.elements[lIndex]
                    break searchRHS
                }
            }
        }
            
        return newSet
    }
    
    /**
    *  Determines whether this set is a proper subset of a given set.
    *
    *  @param superSet Superset to test against.
    *
    *  @return Whether this set is a proper subset of the superset.
    */
    public func isProperSubsetOf(superSet: FiniteSet<T>) -> Bool {
        if self.isSubsetOf(superSet) == true && self.equals(superSet) == false {
            return true
        }
        
        return false
    }
    
    /**
    *  Determines whether this set is a subset of another set.
    *
    *  @param superSet
    *
    *  @return Whether this set is a subset of another set.
    */
    public func isSubsetOf(superSet: FiniteSet<T>) -> Bool {
        for index in 0 ..< self.cardinality() {
            if contains(superSet.elements, self.elements[index]) == false { return false }
        }
        
        return true
    }
    
    /**
    *  Returns the powerset of this set.
    *
    *  @return Powerset of this set.
    */
    public func powerSet() -> FiniteSet<FiniteSet<T>> {
        var newSet = FiniteSet<FiniteSet<T>>()
        
        if self.cardinality() == 0 {
            newSet.elements += FiniteSet<T>.nullSet
            return newSet
        }
        
        var baseElementSet = FiniteSet<T>()
        baseElementSet.elements += self.elements[0]
        var differenceSet = self.difference(baseElementSet)
        
        return differenceSet.powerSet().union(familyPlusElement(self.elements[0], family: differenceSet.powerSet()))
    }
    
    private func familyPlusElement(element: T, family: FiniteSet<FiniteSet<T>>) -> FiniteSet<FiniteSet<T>> {
        var newFamily = FiniteSet<FiniteSet<T>>()
        var elementSet = FiniteSet<T>()
        
        elementSet.elements += element
        
        for index in 0 ..< family.cardinality() {
            newFamily.addElementWithoutCheck(family.elements[index].union(elementSet))
        }
        
        return newFamily
    }
    
    /**
    *  Returns the set-theoretic difference of this set minus the other set.
    *
    *  @param rhs
    *
    *  @return Difference of this set minus the other set.
    */
    public func subtract(rhs: FiniteSet<T>) -> FiniteSet<T> {
        var newSet = FiniteSet<T>()
        
        for lIndex in 0 ..< cardinality() {
            var found = false
            
            searchRHS: for rIndex in 0 ..< rhs.cardinality() {
                if elements[lIndex] == rhs.elements[rIndex] {
                    found = true
                    break searchRHS
                }
            }
            
            if found == false {
                newSet.addElement(elements[lIndex])
            }
        }
        
        return newSet
    }
    
    /**
    *  Returns the union of this set with another set.
    *
    *  @param otherSet
    *
    *  @return Union of this set with another set.
    */
    public func union(otherSet: FiniteSet<T>) -> FiniteSet<T> {
        return self.add(otherSet)
    }
    
    public func generate() -> FiniteSetGenerator<T> {
        return FiniteSetGenerator<T>(elements: elements[0 ..< elements.count])
    }
    
    /**
    *  Getter for subscript based on index.
    */
    public subscript(index: Int) -> T {
        get {
            assert(index < elements.count, "Index out of range")
            return elements[index]
        }
        set {
            assert(index < elements.count, "Index out of range")
            elements[index] = newValue
        }
    }
    
}

public struct FiniteSetGenerator<T: protocol<Equatable, Initable>> : Generator {
    public mutating func next() -> T? {
        if elements.isEmpty {return nil}
        
        let ret = elements[0]
        elements = elements[1 ..< elements.count]
        
        return ret
    }
    
    var elements: Slice<T>
}

public func == <T: protocol<Equatable, Initable>> (lhs: FiniteSet<T>, rhs: FiniteSet<T>) -> Bool {
    return lhs.equals(rhs)
}

public func + <T: protocol<Equatable, Initable>> (lhs: FiniteSet<T>, rhs: FiniteSet<T>) -> FiniteSet<T> {
    return lhs.union(rhs)
}

public func - <T: protocol<Equatable, Initable>> (lhs: FiniteSet<T>, rhs: FiniteSet<T>) -> FiniteSet<T> {
    return lhs.difference(rhs)
}
