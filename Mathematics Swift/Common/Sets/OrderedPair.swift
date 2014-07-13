//
//  OrderedPair.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 6/18/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class OrderedPair<XType: protocol<Equatable, Initable>, YType: protocol<Equatable, Initable>> : Equatable, Initable {
    
    var x = XType()
    var y = YType()
    
    // MARK: - Constructors
    
    init() {}
    
    init(x: XType, y: YType) {
        self.x = x
        self.y = y
    }
    
    
}

func == <XType: protocol<Equatable, Initable>, YType: protocol<Equatable, Initable>> (lhs: OrderedPair<XType, YType>, rhs: OrderedPair<XType, YType>) -> Bool {
    
    if lhs.x == rhs.x && lhs.y == rhs.y { return true }
    
    return false
    
}
