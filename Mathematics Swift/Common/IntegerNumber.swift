//
//  IntegerNumber.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 6/18/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class IntegerNumber : Initable, ISubtractable, IMultipliable, IMultiplicativeIdentity, Comparable, Equatable, IAbsoluteable, Printable {
    
    var value : Int = 0
    
    var description : String {
        return "\(value)"
    }
    
    var additiveIdentity : IntegerNumber {
        return IntegerNumber(value: 0)
    }
    
    var multiplicativeIdentity : IntegerNumber {
        return IntegerNumber(value: 1)
    }
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(value: 0)
    }
    
    init(value: Int) {
        self.value = value
    }
    
    // MARK: - Methods
    
    func absoluteValue() -> IntegerNumber {
        return IntegerNumber(value: abs(value))
    }
    
    func add(rhs: IntegerNumber) -> IntegerNumber {
        return IntegerNumber(value: self.value + rhs.value)
    }
    
    func multiply(rhs: IntegerNumber) -> IntegerNumber {
        return IntegerNumber(value: self.value * rhs.value)
    }
    
    func subtract(rhs: IntegerNumber) -> IntegerNumber {
        return IntegerNumber(value: self.value - rhs.value)
    }
    
}

// MARK: - Operators

func +(lhs: IntegerNumber, rhs: IntegerNumber) -> IntegerNumber {
    return lhs.add(rhs)
}

func -(lhs:IntegerNumber, rhs: IntegerNumber) -> IntegerNumber {
    return lhs.subtract(rhs)
}

func *(lhs: IntegerNumber, rhs: IntegerNumber) -> IntegerNumber {
    return lhs.multiply(rhs)
}

func <=(lhs: IntegerNumber, rhs: IntegerNumber) -> Bool {
    return (lhs.value <= rhs.value)
}

func >=(lhs: IntegerNumber, rhs: IntegerNumber) -> Bool {
    return (lhs.value >= rhs.value)
}

func <(lhs: IntegerNumber, rhs: IntegerNumber) -> Bool {
    return (lhs.value < rhs.value)
}

func >(lhs: IntegerNumber, rhs: IntegerNumber) -> Bool {
    return (lhs.value > rhs.value)
}

func ==(lhs: IntegerNumber, rhs: IntegerNumber) -> Bool {
    return (lhs.value == rhs.value)
}
