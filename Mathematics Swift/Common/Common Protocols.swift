//
//  IAbsoluteable.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 6/18/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

@class_protocol protocol Initable {
//protocol Initable {
    init()
}

protocol IAbsoluteable {
    
    func absoluteValue() -> Self
    
}

protocol IAddable {
    
    func add(rhs: Self) -> Self
    func +(lhs: Self, rhs: Self) -> Self
    
}

protocol IAdditiveIdentity {
    
    var additiveIdentity : Self { get }
    
}

protocol IDividable : IMultipliable, IMultiplicativeIdentity {
    
    func divide(rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    
}

protocol IMultipliable {
    
    func multiply(rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    
}

protocol IMultiplicativeIdentity {
    
    var multiplicativeIdentity : Self { get }
    
}

protocol ISubtractable : IAddable, IAdditiveIdentity {
    
    func subtract(rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    
}
