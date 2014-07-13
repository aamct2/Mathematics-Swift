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
        
        var newOp = self.operation.restriction(newSet)!
        
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
            tup2.elements[0] = applyOperation(tup1)!
            tup2.elements[1] = operation.inverseElement(mySet[index])!
            
            newSet.addElement(applyOperation(tup2)!)
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
        tup2.elements[0] = self.operation.applyMap(tup1)!
        tup2.elements[1] = lhs
        tup3.elements[0] = self.operation.applyMap(tup2)!
        tup3.elements[1] = rhs
        
        return self.applyOperation(tup3)!
    }
    
    /**
    *  Returns the derived subgroup (also known as the commutator subgroup) of this group. In other words, the group whose elements are all the possible commutators of this group.
    *
    *  @return Returns the derived subgroup.
    */
    func derivedSubgroup() -> FiniteGroup<T>? {
        var generatorSet = FiniteSet<T>()
        
        for index1 in 0 ..< self.order() {
            for index2 in 0 ..< self.order() {
                generatorSet.addElement(self.commutator(mySet[index1], rhs: mySet[index2]))
            }
        }
        
        if let newSet = FiniteGroup.generatedSet(generatorSet, theMap: self.operation.relation) {
            var newOperation = self.operation.restriction(newSet)!
            
            return FiniteGroup(mySet: newSet, operation: newOperation, knownProperties: self.subgroupClosedProperties())
        }
        
        return nil
    }
    
    /**
    *  Determines whether a given element generates the group.
    *
    *  @param elem The element to test as a generator of the group.
    *
    *  @return Returns **true** if a given element generates the whole group, **false** otherwise.
    */
    func generatesGroup(elem: T) -> Bool {
        assert(contains(mySet.elements, elem), "The parameter 'elem' is not a member of this group.")
        
        if self.order(elem) == self.order() { return true }
        
        return false
    }
    
    class func generatedSet<T: protocol<Equatable, Initable>>(generatorSet: FiniteSet<T>, theMap: MathMap<Tuple, T>) -> FiniteSet<T>? {
        
        var cycleIndex = 0
        
        var result = FiniteSet<T>()
        result = generatorSet.clone()
        
        while cycleIndex < 3000 {
            var foundNewElement = false
            
            for var index1 = result.cardinality() - 1; index1 >= 0; --index1 {
                var curTup = Tuple(size: 2)
                curTup.elements[0] = result[index1]
                
                for var index2 = result.cardinality() - 1; index2 >= 0; --index2 {
                    curTup.elements[1] = result[index2]
                    
                    if let curElem = theMap.applyMap(curTup) {
                        if contains(result.elements, curElem) == false {
                            result.addElement(curElem)
                            foundNewElement = true
                        }
                    }
                } // End For index2
            } // End For index1
            
            if foundNewElement == false {
                return result
            }
            
            cycleIndex += 1
        } // End While
        
        return nil
    }
    
    /**
    *  Determines whether this group is abelian. In other words, if its operation is commutative.
    *
    *  @return Returns **true** if the group is abelian, **false** otherwise.
    */
    func isAbelian() -> Bool {
        if !(contains(groupProperties.keys, "abelian")) {
            groupProperties["abelian"] = self.operation.isCommutative()
        }
        
        return groupProperties["abelian"]!
    }
    
    /**
    *  Determines whether this group is ambivalent. In other words, if every element and its inverse are conjugates.
    *
    *  @return Returns **true** if the group is ambivalent, **false** otherwise.
    */
    func isAmbivalent() -> Bool {
        if !(contains(groupProperties.keys, "ambivalent")) {
            for index in 0 ..< self.order() {
                var curElem = mySet[index]
                var curInverse = operation.inverseElement(curElem)!
                
                if self.isConjugate(curElem, rhs: curInverse) == false {
                    groupProperties["ambivalen"] = false
                    return false
                }
            }
            
            groupProperties["ambivalen"] = true
        }
        
        return groupProperties["ambivalent"]!
    }
    
    /**
    *  Determines whether two elements of the group are conjugate to eachother. Two elements A and B are conjugate if there exists a G such that G + A + G^-1 = B.
    *
    *  @param lhs The first element.
    *  @param rhs The second element.
    *
    *  @return Returns **true** if the two elements are conjugates, **false** otherwise.
    */
    func isConjugate(lhs: T, rhs: T) -> Bool {
        assert(contains(mySet.elements, lhs), "The parameter 'lhs' is not a member of this group.")
        assert(contains(mySet.elements, rhs), "The parameter 'rhs' is not a member of this group.")
        
        for index in 0 ..< self.order() {
            var tup1 = Tuple(size: 2)
            var tup2 = Tuple(size: 2)
            
            tup1.elements[0] = mySet[index]
            tup1.elements[1] = lhs
            tup2.elements[0] = applyOperation(tup1)!
            tup2.elements[1] = operation.inverseElement(mySet[index])!
            
            if applyOperation(tup2) == rhs {
                return true
            }
        }
        
        return false
    }
    
    /**
    *  Determines whether or not this group is cyclic.
    *
    *  @return Returns **true** if the group is cyclic, **false** otherwise.
    */
    func isCyclic() -> Bool {
        if !(contains(groupProperties.keys, "cyclic")) {
            for index in 0 ..< self.order() {
                if self.generatesGroup(mySet[index]) {
                    groupProperties["cyclic"] = true
                    return true
                }
            }
            
            groupProperties["cyclic"] = false
        }
        
        return groupProperties["cyclic"]!
    }
    
    /**
    *  Determines whether or not this group is a Dedekind group. In other words, that all its subgroups are normal.
    *
    *  @return Returns **true** if the group is a Dedekind group, **false** otherwise.
    */
    func isDedekind() -> Bool {
        if !(contains(groupProperties.keys, "dedekind")) {
            // Abelian implies Dedekind, check to see if we've calculated that already.
            if contains(groupProperties.keys, "abelian") {
                if groupProperties["abelian"] {
                    groupProperties["dedekind"] = true
                    return true
                }
            }
            
            // Nilpotent + T-Group implies Dedekind, check to see if we've calculated that already.
            if contains(groupProperties.keys, "nilpotent") && contains(groupProperties.keys, "t-group") {
                if groupProperties["nilpotent"] && groupProperties["t-group"] {
                    groupProperties["dedekind"] = true
                    return true
                }
            }
            
            if setOfAllSubgroups() == setOfAllNormalSubgroups() {
                groupProperties["dedekind"] = true
            } else {
                groupProperties["dedekind"] = false
            }
        }
        
        return groupProperties["dedekind"]!
    }
    
    /**
    *  Determines whether a given finite set and operation will form a finite group.
    *
    *  @param testSet The finite set to test.
    *  @param testOperation The operation to test.
    *
    *  @return Returns **true** if a given set and operation will form a group, **false** otherwise.
    */
    class func isGroup(testSet: FiniteSet<T>, testOperation: FiniteBinaryOperation<T>) -> Bool {
        return FiniteMonoid<T>.isMonoid(testSet, testOperation: testOperation) && testOperation.hasInverses()
    }
    
    /**
    *  Determines whether a given finite monoid will form a finite group.
    *
    *  @param testMonoid The monoid to test.
    *
    *  @return Returns **true** if a given monoid is also a group, **false** otherwise.
    */
    class func isGroup(testMonoid: FiniteMonoid<T>) -> Bool {
        return testMonoid.operation.hasInverses()
    }
    
    /**
    *  Determines whether or not this group is a Hamiltonian group. In other words, a non-abelian Dedekind group.
    *
    *  @return Returns **true** if the group is a Hamiltonian group, **false** otherwise.
    */
    func isHamiltonian() -> Bool {
        if !(contains(groupProperties.keys, "hamiltonian")) {
            if self.isDedekind() == true && self.isAbelian() == false {
                groupProperties["hamiltonian"] = true
            } else {
                groupProperties["hamiltonian"] = false
            }
        }
        
        return groupProperties["hamiltonian"]!
    }
    
    /**
    *  Determines whether the group is hypoabelian. In other words, that its perfect core is trivial.
    *
    *  @return Returns **true** if the group is hypoabelian, **false** otherwise.
    */
    func isHypoabelian() -> Bool {
        if !(contains(groupProperties.keys, "hypoabelian")) {
            // Solvable implies hypoabelian, check to see if we've calculated that already.
            if contains(groupProperties.keys, "solvable") {
                if groupProperties["solvable"] {
                    groupProperties["hypoabelian"] = true
                    return true
                }
            }
            
            if perfectCore() == trivialSubgroup() {
                groupProperties["hypoabelian"] = true
            } else {
                groupProperties["hypoabelian"] = false
            }
        }
        
        return groupProperties["hypoabelian"]!
    }
    
    /**
    *  Determines whether this group is a maximal subgroup of a given group. A maximal subgroup is a proper subgroup that is not strictly contained by any other proper subgroup.
    *
    *  @param superGroup The supergroup (or ambient group) to test if this group is a maximal subgroup of it.
    *
    *  @return Returns **true** if the group is a maximal subgroup of a given group, **false** otherwise.
    */
    func isMaximalSubgroupOf(superGroup: FiniteGroup<T>) -> Bool {
        // Check to make sure it is a proper subgroup
        if self.isProperSubgroupOf(superGroup) == false { return false }
        
        // Check to make sure no other proper subgroup strictly contains this group
        var allSupergroupSubgroups = superGroup.setOfAllSubgroups()
        for subgroup in allSupergroupSubgroups {
            if !(self == subgroup) {
                if subgroup.mySet.isProperSubsetOf(superGroup.mySet) && self.isSubgroupOf(subgroup) {
                    return false
                }
            }
        }
        
        return true
    }
    
    /**
    *  Determines whether this group is a normal subgroup of another group. A subgroup is normal if and only if all left and right cosets coincide.
    *
    *  @param superGroup The supergroup (or ambient group) to test if this group is a normal subgroup of it.
    *
    *  @return Returns **true** if the group is a normal subgroup of a given group, **false** otherwise.
    */
    func isNormalSubgroupOf(superGroup: FiniteGroup<T>) -> Bool {
        // First check to make sure it is a subgroup
        if self.isSubgroupOf(superGroup) == false { return false }
        
        // Check to see if it is the whole group, which is trivially normal
        if self.order() == superGroup.order() { return true }
        
        // Check to see if it is of index 2, which would quickly imply that it is normal
        if self.subgroupIndex(superGroup) == 2.0 { return true }
        
        // Alright, crank it the long way
        for index in 0 ..< superGroup.mySet.cardinality() {
            if !(superGroup.leftCoset(self, elem: superGroup.mySet[index]) == superGroup.rightCoset(self, elem: superGroup.mySet[index])) {
                return false
            }
        }
        
        return true
    }
    
    /**
    *  Determines whether this group is perfect. In other words, it is equal to its derived subgroup.
    *
    *  @return Returns **true** if the group is perfect, **false** otherwise.
    */
    func isPerfect() -> Bool {
        if !(contains(groupProperties.keys, "perfect")) {
            if let myDerivedSubgroup = self.derivedSubgroup() {
                if self == myDerivedSubgroup {
                    groupProperties["perfect"] = true
                    return true
                }
            }
            
            groupProperties["perfect"] = false
        }
        
        return groupProperties["perfect"]!
    }
    
    /**
    *  Determines whether this group is a proper subgroup of a given group. In other words it is a subgroup but not equal to the whole group.
    *
    *  @param superGroup The supergroup (or ambient group) to test if this group is a proper subgroup of it.
    *
    *  @return Returns **true** if the group is a proper subgroup of a given group, **false** otherwise.
    */
    func isProperSubgroupOf(superGroup: FiniteGroup<T>) -> Bool {
        // Check to make sure it is a subgroup
        if self.isSubgroupOf(superGroup) == false { return false }
        
        // Check to make sure it's a proper subgroup
        if self.mySet.isProperSubsetOf(superGroup.mySet) == false { return false }
        
        return true
    }
    
    /**
    *  Determines whether this group is simple. In other words, if this group's only normal subgroups is the group itself and the trivial subgroup.
    *
    *  @return Returns **true** if the group is simple, **false** otherwise.
    */
    func isSimple() -> Bool {
        if !(contains(groupProperties.keys, "simple")) {
            // Check to make sure the group's only normal subgroups are itself and the trivial subgroup
            // And check to make sure it is not the trivial group itself
            if self.setOfAllNormalSubgroups().cardinality() <= 2 && self.order() > 1 {
                groupProperties["simple"] = true
            } else {
                groupProperties["simple"] = false
            }
        }
        
        return groupProperties["simple"]!
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
    *  Returns the left coset of a particular element with a particular subgroup.
    *
    *  @param subgroup The subgroup with which to form the left coset.
    *  @param elem The element whose left coset is to be returned.
    *
    *  @return The left coset of a given element and given subgroup.
    */
    func leftCoset(subgroup: FiniteGroup<T>, elem: T) -> FiniteSet<T> {
        assert(subgroup.isSubgroupOf(self), "The parameter 'subgroup' is not a subgroup of this group.")
        assert(contains(self.mySet.elements, elem), "The parameter 'elem' is not an element of this group.")
        
        var newSet = FiniteSet<T>()
        
        for index in 0 ..< self.mySet.cardinality() {
            var curTup = Tuple(size: 2)
            
            curTup.elements[0] = elem
            curTup.elements[1] = subgroup.mySet[index]
            
            newSet.addElement(self.applyOperation(curTup)!)
        }
        
        return newSet
    }
    
    /**
    *  Returns the order of the group.
    *
    *  @return The order of the group.
    */
    func order() -> Int {
        return self.mySet.cardinality()
    }
    
    /**
    *  Returns the order of a particular element of the group.
    *
    *  @param elem The element whose order is to be returned.
    *
    *  @return The order of a given element.
    */
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
            curPwr = self.applyOperation(curTup)!
            
            if curPwr == self.identity {
                return possibleOrders[index]
            }
        }
        
        fatalError("Error: Could not find order of element?! There must be a problem with the code.")
    }
    
    /**
    *  Returns the perfect core of the group. In other words, its largest perfect subgroup.
    *
    *  @return Returns the perfect core of the group.
    */
    func perfectCore() -> FiniteGroup<T> {
        var allMySubgroups = self.setOfAllSubgroups()
        var perfectSubgroups = FiniteSet<FiniteGroup<T>>()
        
        // Find all the perfect subgroups
        for subgroup in allMySubgroups {
            if subgroup.isPerfect() {
                perfectSubgroups.addElement(subgroup)
            }
        }
        
        // Find the largest one
        var largestIndex = 0
        for index in 0 ..< perfectSubgroups.cardinality() {
            if perfectSubgroups[index].order() > perfectSubgroups[largestIndex].order() {
                largestIndex = index
            }
        }
        
        return perfectSubgroups[largestIndex]
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
            x = self.applyOperation(curTup)!
        }
        
        while curExponent > 1 {
            curTup.elements[0] = g
            curTup.elements[1] = g
            g = self.applyOperation(curTup)!
            
            curExponent = curExponent / 2
            
            if curExponent % 2 == 1 {
                curTup.elements[0] = x
                curTup.elements[1] = g
                x = self.applyOperation(curTup)!
            }
        }
        
        return x
    }
    
    /**
    *  Returns the right coset of a particular element with a particular subgroup.
    *
    *  @param subgroup The subgroup with which to form the right coset.
    *  @param elem The element whose right coset is to be returned.
    *
    *  @return The right coset of a given element and a given subgroup.
    */
    func rightCoset(subgroup: FiniteGroup<T>, elem: T) -> FiniteSet<T> {
        assert(subgroup.isSubgroupOf(self), "The parameter 'subgroup' is not a subgroup of this group.")
        assert(contains(self.mySet.elements, elem), "The parameter 'elem' is not an element of this group.")
        
        var newSet = FiniteSet<T>()
        
        for index in 0 ..< self.mySet.cardinality() {
            var curTup = Tuple(size: 2)
            
            curTup.elements[0] = subgroup.mySet[index]
            curTup.elements[1] = elem
            
            newSet.addElement(self.applyOperation(curTup)!)
        }
        
        return newSet
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
    *  Returns the set of all maximal subgroups of this group (does NOT include improper subgroups). A maximal subgroup is a proper subgroup that is not strictly contained by any other proper subgroup.
    *
    *  @return The set of all maximal subgroups.
    */
    func setOfAllMaximalSubgroups() -> FiniteSet<FiniteGroup<T>> {
        var newSet = FiniteSet<FiniteGroup<T>>()
        
        var subgroups = setOfAllSubgroups()
        
        for subgroup in subgroups {
            if subgroup.isMaximalSubgroupOf(self) {
                newSet.addElement(subgroup)
            }
        }
        
        return newSet
    }
    
    /**
    *  Returns the set of all normal subgroups of this group (includes improper subgroups).
    *
    *  @return The set of all normal subgroups.
    */
    func setOfAllNormalSubgroups() -> FiniteSet<FiniteGroup<T>> {
        if !(contains(groupProperties.keys, "all normal subgroups")) {
            // Check to see if it is an abelian group, makes this trivial
            if contains(groupProperties.keys, "abelian") {
                if groupProperties["abelian"] == true {
                    allNormalSubgroups = setOfAllSubgroups()
                    groupProperties["all normal subgroups"] = true
                    return allNormalSubgroups!.clone()
                }
            }
            
            var subgroups = setOfAllSubgroups()
            var newSet = FiniteSet<FiniteGroup<T>>()
            
            for subgroup in subgroups {
                if subgroup.isNormalSubgroupOf(self) {
                    newSet.addElement(subgroup)
                }
            }
            
            allNormalSubgroups = newSet
            groupProperties["all normal subgroups"] = true
        }
        
        return allNormalSubgroups!.clone()
    }
    
    func setOfAllSubgroups() -> FiniteSet<FiniteGroup<T>> {
        if !(contains(groupProperties.keys, "all subgroups")) {
            var newSet = FiniteSet<FiniteGroup<T>>()
            
            var modifiedSet = mySet.clone()
            modifiedSet.deleteElement(modifiedSet.indexOf(self.identity))
            
            // Generating the powerset is an expensive operation.
            // All subgroups must contain the identity element. So remove it, then create the powerset, then add it back in to each of these candidates.
            var pwrSet = modifiedSet.powerSet()
            for index in 0 ..< pwrSet.cardinality() {
                var curSet = pwrSet[index]
                curSet.addElementWithoutCheck(self.identity)
                
                pwrSet[index] = curSet
            }
            
            // Order of the subgroup must divide the order of the group (finite only)
            // So only bother trying those
            for var index = pwrSet.cardinality() - 1; index >= 0; --index {
                if self.order() % pwrSet[index].cardinality() != 0 {
                    pwrSet.deleteElement(index)
                }
            }
            
            var knownProps = self.subgroupClosedProperties()
            
            for index in 0 ..< pwrSet.cardinality() {
                if let newOp = operation.restriction(pwrSet[index]) {
                    if FiniteGroup<T>.isGroup(pwrSet[index], testOperation: newOp) {
                        newSet.addElement(FiniteGroup<T>(mySet: pwrSet[index], operation: newOp, knownProperties: knownProps))
                    } else {
                        // If there was an exception, the operation does not exist, so that element of the power set is not a group
                    }
                }
            } // End For index
            
            allSubgroups = newSet
            groupProperties["all subgroups"] = true
        }
        
        return allSubgroups!.clone()
    }
    
    /**
    *  Returns the index of this group as a subgroup of a given supergroup.
    *
    *  @param superGroup The superGroup of this group for which the index is to be returned.
    *
    *  @return The index of this group as a subgroup of a given supergroup.
    */
    func subgroupIndex(superGroup: FiniteGroup<T>) -> Double {
        assert(self.isSubgroupOf(superGroup), "This group is not a subgroup of the parameter 'superGroup'.")
        
        return Double(self.order()) / Double(superGroup.order())
    }
    
    /**
    *  Returns the trivial subgroup of this group.
    *
    *  @return The trivial subgroup of this group.
    */
    func trivialSubgroup() -> FiniteGroup<T> {
        var newSet = FiniteSet<T>()
        newSet.addElement(self.identity)
        
        var newOp = self.operation.restriction(newSet)!
        
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

    // MARK: - Custom Maps
    
    class QuotientMap<T: protocol<Equatable, Initable>> : MathMap<Tuple, FiniteSet<T>> {
        var groupMap: MathMap<Tuple, T>
        
        init(groupMap: MathMap<Tuple, T>) {
            self.groupMap = groupMap
        }

        override func applyMap(input: Tuple) -> FiniteSet<T>? {
            var newSet = FiniteSet<T>()
            
            var set1 = input.elements[0] as FiniteSet<T>
            var set2 = input.elements[1] as FiniteSet<T>
            
            for index1 in 0 ..< set1.cardinality() {
                for index2 in 0 ..< set2.cardinality() {
                    var curTup = Tuple(size: 2)
                    curTup.elements[0] = set1[index1]
                    curTup.elements[1] = set2[index2]

                    if let newElem = self.groupMap.applyMap(curTup) {
                        newSet.addElement(newElem)
                    } else {
                        return nil
                    }
                } // End For index2
            } // End For index1

            return newSet
        }
    }
    
}

func == <T: protocol<Equatable, Initable>> (lhs: FiniteGroup<T>, rhs: FiniteGroup<T>) -> Bool {
    return lhs.mySet == rhs.mySet && lhs.operation == rhs.operation
}
