//
//  GameBoardLayout.swift
//  tetris
//
//  Created by Khim Bahadur Gurung on 12.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//

class GameBoardLayout<Layout> {
    let columns: Int
    let rows: Int
    
    var array: Array<Layout?>
    
    init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
        
        array = Array<Layout?>(repeating: nil, count:rows * columns)
    }
    //to set and retrive values without seperate methods for setting and retrieval
    subscript(column: Int, row: Int) -> Layout? {
        get{
            return array[(row * columns) + column]
        }
        
        set(newValue){
            array[(row * columns) + column] = newValue
        }
    }
}

