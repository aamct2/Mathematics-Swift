//
//  RealNumber.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/12/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class RealNumber : Comparable, Initable, IAbsoluteable, IDividable, ISubtractable {
    var value : Double = 0.0
    
    init() {}
    
    init(value: Double) {
        self.value = value
    }
    
    var additiveIdentity : RealNumber {
        return RealNumber(value: 0.0)
    }
    
    var multiplicativeIdentity: RealNumber {
        return RealNumber(value: 1.0)
    }
    
    // MARK: - Methods
    
    func absoluteValue() -> RealNumber {
        return RealNumber(value: fabs(self.value))
    }
    
    func add(rhs: RealNumber) -> RealNumber {
        return RealNumber(value: self.value + rhs.value)
    }
    
    func divide(rhs: RealNumber) -> RealNumber {
        assert(!(rhs == self.additiveIdentity), "rhs cannot be zero.")
        
        return RealNumber(value: self.value / rhs.value)
    }
    
    class func ln(rhs: RealNumber) -> RealNumber {
        assert(rhs.value != 0, "rhs cannot be zero.")
        
        return RealNumber(value: log(rhs.value))
    }
    
    func multipy(rhs: RealNumber) -> RealNumber {
        return RealNumber(value: self.value * rhs.value)
    }
    
    func subtract(rhs: RealNumber) -> RealNumber {
        return RealNumber(value: self.value - rhs.value)
    }
    
    func power(rhs: RealNumber) -> RealNumber {
        return RealNumber(value: pow(self.value, rhs.value))
    }
}

func == (lhs: RealNumber, rhs: RealNumber) -> Bool {
    return lhs.value == rhs.value
}

func < (lhs: RealNumber, rhs: RealNumber) -> Bool {
    return lhs.value < rhs.value
}

func + (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
    return lhs.add(rhs)
}

func - (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
    return lhs.subtract(rhs)
}

func * (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
    return lhs.multipy(rhs)
}

func / (lhs: RealNumber, rhs: RealNumber) -> RealNumber {
    return lhs.divide(rhs)
}
