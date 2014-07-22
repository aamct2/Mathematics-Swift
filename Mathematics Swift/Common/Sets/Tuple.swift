//
//  Tuple.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/7/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

public class Tuple : Equatable, Initable {
    var size = 0
    var elements = [AnyObject]()
    
    // MARK: - Constructors
    
    public init() {}
    
    public init(size: Int) {
        self.size = size
        
        for index in 0 ..< size {
            elements += ""
        }
    }
    
    public init(elements: [AnyObject]) {
        self.size = elements.count
        self.elements = elements
    }
    
    // MARK: - Methods
    
    public func equals(otherTuple: Tuple) -> Bool {
        // Make sure the tuples are of the same size
        if self.size != otherTuple.size { return false }
        
        for index in 0 ..< self.size {
            // Make sure the elements are of the same type
            // TODO: Finish
            
        }
        
        return true
    }
    
}

public func == (lhs: Tuple, rhs: Tuple) -> Bool {
    return lhs.equals(rhs)
}
