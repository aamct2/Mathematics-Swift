//
//  Matrix.swift
//  Mathematics Swift
//
//  Created by Aaron McTavish on 7/9/14.
//  Copyright (c) 2014 Aaron McTavish. All rights reserved.
//

import Foundation

class Matrix<T: protocol<IAbsoluteable, IDividable, ISubtractable, Comparable, Initable>> : ISubtractable, Equatable {
    
    var elements = Array(count:9, repeatedValue:T())
    
    let rows: Int, columns: Int
    
    var size : Int {
        return rows * columns
    }
    
    var additiveIdentity : Matrix<T> {
        return Matrix<T>(rows: self.rows, columns: self.columns)
    }
    
    convenience init() {
        self.init(rows: 3, columns: 3)
    }
    
    /**
    *  Intializes a matrix with all zeros.
    *
    *  @param rows The number of rows in the matrix.
    *  @param columns The number of columns in the matrix.
    */
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        let exampleT = T()
        
        // TODO: Fix
        //elements = Array(count:size, repeatedValue:exampleT.additiveIdentity)
    }
    
    // MARK: - Methods
    
    func add(rhs: Matrix<T>) -> Matrix<T> {
        assert(self.rows == rhs.rows, "Matrix addition requires the number of rows to be the same")
        assert(self.columns == rhs.columns, "Matrix addition requires the number of columns to be the same")
        
        var result = Matrix<T>(rows: self.rows, columns: self.columns)
        
        for rowIndex in 0 ..< self.rows {
            for colIndex in 0 ..< self.columns {
                var lhsValue = self[rowIndex, colIndex]
                var rhsValue = rhs[rowIndex, colIndex]
                
                result[rowIndex, colIndex] = lhsValue + rhsValue
            }
        }
        
        return result
    }
    
    /**
    *  Returns an array of the values in a particular row.
    *
    *  @param rowIndex Index of the row.
    *
    *  @return Array of the values in a particular row.
    */
    func getRow(rowIndex: Int) -> [T] {
        var row = Array(count:columns, repeatedValue:T())
        
        for colIndex in 0 ..< columns {
            row[colIndex] = self[rowIndex, colIndex]
        }
        
        return row
    }
    
    /**
    *  Returns an array of the values in a particular column.
    *
    *  @param colIndex Index of the column.
    *
    *  @return Array of the values in a particular column.
    */
    func getCol(colIndex: Int) -> [T] {
        var col = Array(count:rows, repeatedValue:T())
        
        for rowIndex in 0 ..< rows {
            col[rowIndex] = self[rowIndex, colIndex]
        }
        
        return col
    }
    
    func hadamardProduct(rhs: Matrix<T>) -> Matrix<T> {
        assert(self.rows == rhs.rows, "Matrix Hadamard Product requires the number of rows to be the same")
        assert(self.columns == rhs.columns, "Matrix Hadamard Product requires the number of columns to be the same")
        
        var result = Matrix<T>(rows: self.rows, columns: self.columns)
        
        for rowIndex in 0 ..< self.rows {
            for colIndex in 0 ..< self.columns {
                var lhsValue = self[rowIndex, colIndex]
                var rhsValue = rhs[rowIndex, colIndex]
                
                result[rowIndex, colIndex] = lhsValue * rhsValue
            }
        }
        
        return result
    }
    
    func isSquare() -> Bool {
        if rows == columns {
            return true
        }
        
        return false
    }
    
    /**
    *  Generates the minor of the matrix by removing the row at rowIndex and column at columnIndex.
    *
    *  @param rowIndex Index of the row to be removed.
    *  @param columnIndex Index of the column to be removed.
    *
    *  @return The minor matrix.
    */
    func minor(#rowIndex: Int, columnIndex: Int) -> Matrix<T> {
        assert(indexIsValideForRow(rowIndex, column: columnIndex), "Row and/or Column indices do not lie within the matrix.")
        
        let minorMatrix = Matrix<T>(rows: rows - 1, columns: columns - 1)
        var minorRow = 0
        var minorColumn = 0
        
        for row in 0 ..< rows {
            for col in 0 ..< columns {
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
    
    func subtract(rhs: Matrix<T>) -> Matrix<T> {
        assert(self.rows == rhs.rows, "Matrix subtraction requires the number of rows to be the same")
        assert(self.columns == rhs.columns, "Matrix addition requires the number of columns to be the same")
        
        var result = Matrix<T>(rows: self.rows, columns: self.columns)
        
        for rowIndex in 0 ..< self.rows {
            for colIndex in 0 ..< self.columns {
                var lhsValue = self[rowIndex, colIndex]
                var rhsValue = rhs[rowIndex, colIndex]
                
                result[rowIndex, colIndex] = lhsValue - rhsValue
            }
        }
        
        return result
    }
    
    /**
    *  Determines if a row, column index pair is valid within the matrix.
    *
    *  @param row Row index.
    *  @param column Column index.
    *
    *  @return Whether a row, column index pair is valid within the matrix
    */
    func indexIsValideForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    /**
    *  Getter for subscript based on row, column.
    *
    *  @param row Row index.
    *  @param column Column index.
    *
    *  @return The value in the matrix at row, column.
    */
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValideForRow(row, column: column), "Index out of range")
            return elements[row * columns + column]
        }
        set {
            assert(indexIsValideForRow(row, column: column), "Index out of range")
            elements[row * columns + column] = newValue
        }
    }
    
}

/**
*  Determines whether the two matrices are equivalent.
*
*  @param lhs Left matrix.
*  @param rhs Right matrix.
*
*  @return Whether the two matrices are equivalent.
*/
func == <T: protocol<IDividable, ISubtractable, Comparable, Initable>> (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    if lhs.rows != rhs.rows { return false }
    if lhs.columns != rhs.columns { return false }
    
    for rowIndex in 0 ..< lhs.rows {
        for colIndex in 0 ..< rhs.columns {
            if lhs[rowIndex, colIndex] != rhs[rowIndex, colIndex] { return false }
        }
    }
    
    return true
}

/**
*  Matrix Addition
*
*  @param lhs Left matrix.
*  @param rhs Right matrix.
*
*  @return The matrix result of the matrix addition.
*/
func + <T: protocol<IDividable, ISubtractable, Comparable, Initable>> (lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
    return lhs.add(rhs)
}

func - <T: protocol<IDividable, ISubtractable, Comparable, Initable>> (lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T> {
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
func * <T: protocol<IDividable, ISubtractable, Comparable, Initable>> (lhs: T, rhs: Matrix<T>) -> Matrix<T> {
    var result = Matrix<T>(rows: rhs.rows, columns: rhs.columns)
    
    result.elements = rhs.elements.map { $0 * lhs }
    
    return result
}
