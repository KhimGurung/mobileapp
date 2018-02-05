//
//  Block.swift
//  tetris
//
//  Created by Khim Bahadur Gurung on 17.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//
import SpriteKit

class Block: Hashable {

    // Properties to locat location of block
    var color:String
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    var hashValue: Int {
        return self.column ^ self.row
    }
    func blockColor()->String{
        return self.color
    }
    func setBlockColor(blockClr: String){
        print(blockClr)
        self.color = blockClr
    }
    init(column:Int, row:Int, color:String) {
        //print(self.color)
        self.column = column
        self.row = row
        self.color = color
    }
}

//distinguishing cases where the left hand value is greater than or les than the right than value
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
