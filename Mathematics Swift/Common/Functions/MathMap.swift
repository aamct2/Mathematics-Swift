//
//  MathMap.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/8/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class MathMap<T: protocol<Equatable, Initable>, G: protocol<Equatable, Initable>> {
    func applyMap(input: T) -> G? {
        // TODO: Finish
        
        return G()
    }
}

class SetDefinedMap<X: protocol<Equatable, Initable>, Y: protocol<Equatable, Initable>> : MathMap<X, Y> {
    var relation = FiniteSet<OrderedPair<X, Y>>()
    
    init(relation: FiniteSet<OrderedPair<X, Y>>) {
        self.relation = relation
    }
    
    override func applyMap(input: X) -> Y {
        for index in 0 ..< self.relation.cardinality() {
            if relation[index].x == input {
                return relation[index].y
            }
        }
        
        fatalError("Undefined Exception: The input value is not a valid input for this map.")
    }
}

class CompositionMap<T: protocol<Equatable, Initable>, Intermediary: protocol<Equatable, Initable>, G: protocol<Equatable, Initable>> : MathMap<T, G> {
    
    var innerMap = MathMap<T, Intermediary>()
    var outerMap = MathMap<Intermediary, G>()
    
    init(innerMap: MathMap<T, Intermediary>, outerMap: MathMap<Intermediary, G>) {
        self.innerMap = innerMap
        self.outerMap = outerMap
    }
    
    override func applyMap(input: T) -> G?  {
        if let innerValue = innerMap.applyMap(input) {
            return outerMap.applyMap(innerValue)
        }
        
        return nil
    }
    
}
