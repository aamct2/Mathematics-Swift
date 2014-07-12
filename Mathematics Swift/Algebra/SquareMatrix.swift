//
//  SquareMatrix.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/12/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class SquareMatrix<T: protocol<IAbsoluteable, IDividable, ISubtractable, Comparable, Initable>> : Matrix<T>, IMultipliable, IMultiplicativeIdentity {
    
    // MARK: - Constructors
    
    init() {
        super.init(rows: 3, columns: 3)
    }
    
    init(rows: Int) {
        super.init(rows: rows, columns: rows)
    }
    
    // MARK: - Properties
    
    override var additiveIdentity : SquareMatrix<T> {
        return SquareMatrix<T>(rows: self.rows)
    }
    
    var multiplicativeIdentity : SquareMatrix<T> {
        var result = SquareMatrix(rows: rows)
            
        var exampleT = T()
    
        // TODO: Fix
        /*
        for rowIndex in 0 ..< rows {
            for colIndex in 0 ..< columns {
                if rowIndex == colIndex {
                    result[rowIndex, colIndex] = exampleT.multiplicativeIdentity
                } else {
                    result[rowIndex, colIndex] = exampleT.additiveIdentity
                }
            }
        }
        */
            
        return result
    }
    
    // MARK: - Methods
    
    func add(rhs: SquareMatrix<T>) -> SquareMatrix<T> {
        assert(self.rows == rhs.rows, "Matrix addition requires the number of rows to be the same")
        
        var result = SquareMatrix<T>(rows: self.rows)
        
        for rowIndex in 0..<self.rows {
            for colIndex in 0..<self.columns {
                var lhsValue = self[rowIndex, colIndex]
                var rhsValue = rhs[rowIndex, colIndex]
                
                result[rowIndex, colIndex] = lhsValue + rhsValue
            }
        }
        
        return result
    }
    
    func hadamardProduct(rhs: SquareMatrix<T>) -> SquareMatrix<T> {
        assert(self.rows == rhs.rows, "Matrix Hadamard Product requires the number of rows to be the same")
        
        var result = SquareMatrix<T>(rows: self.rows)
        
        for rowIndex in 0..<self.rows {
            for colIndex in 0..<self.columns {
                var lhsValue = self[rowIndex, colIndex]
                var rhsValue = rhs[rowIndex, colIndex]
                
                result[rowIndex, colIndex] = lhsValue * rhsValue
            }
        }
        
        return result
    }
    
    /**
    *  Generates the minor of the matrix by removing the row at rowIndex and column at columnIndex.
    *
    *  @param rowIndex Index of the row to be removed.
    *  @param columnIndex Index of the column to be removed.
    *
    *  @return The minor matrix.
    */
    override func minor(#rowIndex: Int, columnIndex: Int) -> SquareMatrix<T> {
        assert(indexIsValideForRow(rowIndex, column: columnIndex), "Row and/or Column indices do not lie within the matrix.")
        
        let minorMatrix = SquareMatrix<T>(rows: rows - 1)
        var minorRow = 0
        var minorColumn = 0
        
        for row in 0..<rows {
            for col in 0..<columns {
                if row != rowIndex && col != columnIndex {
                    minorMatrix[minorRow, minorColumn] = self[row, col]
                    
                    minorColumn++
                    
                    if minorColumn > columns - 2 {
                        minorColumn = 0
                        minorRow++
                    }
                }
            } // End For Col
        } // End For Row
        
        return minorMatrix
    }
    
    func multiply(rhs: SquareMatrix<T>) -> SquareMatrix<T> {
        assert(self.rows == rhs.columns, "Matrix multiplication requires lhs.height == rhs.width")
        
        var result = SquareMatrix(rows: rhs.rows)
        
        for rowIndex in 0 ..< self.rows {
            for colIndex in 0 ..< rhs.columns {
                var row = self.getRow(rowIndex)
                var col = rhs.getCol(colIndex)
                
                var newValue = T()
                for index in 0 ..< row.count {
                    newValue = newValue + (row[index] * col[index])
                }
                
                result[rowIndex, colIndex] = newValue
            }
        }
        
        return result
    }
    
    func subtract(rhs: SquareMatrix<T>) -> SquareMatrix<T> {
        assert(self.rows == rhs.rows, "Matrix subtraction requires the number of rows to be the same")
        
        var result = SquareMatrix<T>(rows: self.rows)
        
        for rowIndex in 0..<self.rows {
            for colIndex in 0..<self.columns {
                var lhsValue = self[rowIndex, colIndex]
                var rhsValue = rhs[rowIndex, colIndex]
                
                result[rowIndex, colIndex] = lhsValue - rhsValue
            }
        }
        
        return result
    }
    
}

/**
*  Matrix Addition
*
*  @param lhs Left matrix.
*  @param rhs Right matrix.
*
*  @return The matrix result of the matrix addition.
*/
func + <T: protocol<IAbsoluteable, IDividable, ISubtractable, Comparable, Initable>> (lhs: SquareMatrix<T>, rhs: SquareMatrix<T>) -> SquareMatrix<T> {
    return lhs.add(rhs)
}

func - <T: protocol<IAbsoluteable, IDividable, ISubtractable, Comparable, Initable>> (lhs: SquareMatrix<T>, rhs: SquareMatrix<T>) -> SquareMatrix<T> {
    return lhs.subtract(rhs)
}

/**
*  Scalar Multiplication
*
*  @param lhs Scalar
*  @param rhs Matrix
*
*  @return The matrix result of the scalar multiplication.
*/
func * <T: protocol<IAbsoluteable, IDividable, ISubtractable, Comparable, Initable>> (lhs: T, rhs: SquareMatrix<T>) -> SquareMatrix<T> {
    var result = SquareMatrix<T>(rows: rhs.rows)
    
    result.elements = rhs.elements.map { $0 * lhs }
    
    return result
}

func * <T: protocol<IAbsoluteable, IDividable, ISubtractable, Comparable, Initable>> (lhs: SquareMatrix<T>, rhs: SquareMatrix<T>) -> SquareMatrix<T> {
    return lhs.multiply(rhs)
}
