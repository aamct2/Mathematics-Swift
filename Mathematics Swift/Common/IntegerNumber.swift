//
//  IntegerNumber.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 6/18/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class IntegerNumber : NSObject, ISubtractable, IMultipliable, IMultiplicativeIdentity, Comparable, Equatable, IAbsoluteable, Printable {
    
    var value : Int = 0
    
    override var description : String {
        return "\(value)"
    }
    
    var additiveIdentity : IntegerNumber {
        return IntegerNumber(value: 0)
    }
    
    var multiplicativeIdentity : IntegerNumber {
        return IntegerNumber(value: 1)
    }
    
    // MARK: - Initializers
    
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
    
    func multipy(rhs: IntegerNumber) -> IntegerNumber {
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
    return lhs.multipy(rhs)
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
