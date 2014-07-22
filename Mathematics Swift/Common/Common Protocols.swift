//
//  IAbsoluteable.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 6/18/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

@class_protocol public protocol Initable {
//protocol Initable {
    init()
}

public protocol IAbsoluteable {
    
    func absoluteValue() -> Self
    
}

public protocol IAddable {
    
    func add(rhs: Self) -> Self
    func +(lhs: Self, rhs: Self) -> Self
    
}

public protocol IAdditiveIdentity {
    
    var additiveIdentity : Self { get }
    
}

public protocol IDividable : IMultipliable, IMultiplicativeIdentity {
    
    func divide(rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    
}

public protocol IMultipliable {
    
    func multiply(rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    
}

public protocol IMultiplicativeIdentity {
    
    var multiplicativeIdentity : Self { get }
    
}

public protocol ISubtractable : IAddable, IAdditiveIdentity {
    
    func subtract(rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    
}
