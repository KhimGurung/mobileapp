//
//  GameLogic.swift
//  mobileapp-tetris
//
//  Created by Khim Bahadur Gurung on 19.01.18.
//  Copyright © 2018 Khim Bahadur Gurung. All rights reserved.
//

let NumColumns = 12
let NumRows = 20

let StartingColumn = 4
let StartingRow = 0

//preview of position of next comming shape
let PreviewColumn = 14
let PreviewRow = 1

let PointsPerLine = 10
let MaximumPoint = 50

protocol GameLogicDelegate {

    func gameDidEnd(gamelogic: GameLogic)
    
    func gameDidBegin(gamelogic: GameLogic)
    
    func gameShapeDidLand(gamelogic: GameLogic)
    
    func gameShapeDidMove(gamelogic: GameLogic)
    
    func gameShapeDidDrop(gamelogic: GameLogic)
    
    func gameDidLevelUp(gamelogic: GameLogic)
}

class GameLogic {
    var blockArray:GameBoardLayout<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    var delegate:GameLogicDelegate?
    var score = 0
    var level = 1
    
    
    
    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = GameBoardLayout<Block>(columns: NumColumns, rows: NumRows)
    }
    
    
    

    
    //start game
    func gameStart() {
        if (nextShape == nil) {
            nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        }
        delegate?.gameDidBegin(gamelogic: self)
    }
    
    
    
    
    //takes next coming shape to falling and pick next shape randomly
    func otherShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        //takes next random shape from random function of shape class
        nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(column: StartingColumn, row: StartingRow)
        
        guard shapeMissplaceDetection() == false else {
            nextShape = fallingShape
            nextShape!.moveTo(column: PreviewColumn, row: PreviewRow)
            endGame()
            return (nil, nil)
        }
        
        return (fallingShape, nextShape)
    }
    
    
    
    
    
    //end game
    func endGame() {
        score = 0
        score = 1
        delegate?.gameDidEnd(gamelogic: self)
    }
    
    
    
    
    
    //missplace detection
    func shapeMissplaceDetection() -> Bool {
        guard let shape = fallingShape else {
            return false
        }
        for block in shape.blocks {
            if block.column < 0 || block.column >= NumColumns || block.row < 0 || block.row >= NumRows {
                return true
            } else if blockArray[block.column, block.row] != nil {
                return true
            }
        }
        return false
    }
    
    
    
    
    
    
    func dropShape() {
        guard let shape = fallingShape else {
            return
        }
        while shapeMissplaceDetection() == false {
            shape.lowerShapeByOneRow()
        }
        shape.raiseShapeByOneRow()
        delegate?.gameShapeDidDrop(gamelogic: self)
    }
    

    
    
    
    
    
    func letShapeFall() {
        guard let shape = fallingShape else {
            return
        }
        shape.lowerShapeByOneRow()
        if shapeMissplaceDetection() {
            shape.raiseShapeByOneRow()
            if shapeMissplaceDetection() {
                endGame()
            } else {
                settleShape()
            }
        } else {
            delegate?.gameShapeDidMove(gamelogic: self)
            if detectTouch() {
                settleShape()
            }
        }
    }
    

    
    func rotateShape() {
        guard let shape = fallingShape else {
            return
        }
        shape.rotateClockwise()
        guard shapeMissplaceDetection() == false else {
            shape.rotateAnticlockwise()
            return
        }
        delegate?.gameShapeDidMove(gamelogic: self)
    }
    
    
    
    
    
    func moveShapeLeft() {
        guard let shape = fallingShape else {
            return
        }
        shape.shiftLeftByOneColumn()
        guard shapeMissplaceDetection() == false else {
            shape.shiftRightByOneColumn()
            return
        }
        delegate?.gameShapeDidMove(gamelogic: self)
    }
    
    
    
    
    
    
    func moveShapeRight() {
        guard let shape = fallingShape else {
            return
        }
        shape.shiftRightByOneColumn()
        guard shapeMissplaceDetection() == false else {
            shape.shiftLeftByOneColumn()
            return
        }
        delegate?.gameShapeDidMove(gamelogic: self)
    }
    
    
    
    
    
    
    func settleShape() {
        guard let shape = fallingShape else {
            return
        }
        for block in shape.blocks {
            blockArray[block.column, block.row] = block
        }
        fallingShape = nil
        delegate?.gameShapeDidLand(gamelogic: self)
    }
    
    
    
    
    
    
    func detectTouch() -> Bool {
        guard let shape = fallingShape else {
            return false
        }
        for bottomBlock in shape.bottomBlocks {
            if bottomBlock.row == NumRows - 1 || blockArray[bottomBlock.column, bottomBlock.row + 1] != nil {
                return true
            }
        }
        return false
    }
    
    
    
    
    
    
    func removeCompletedLines() -> (linesRemoved: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>) {
        var removedLines = Array<Array<Block>>()
        for row in (1..<NumRows).reversed() {
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns {
                guard let block = blockArray[column, row] else {
                    continue
                }
                rowOfBlocks.append(block)
            }
            if rowOfBlocks.count == NumColumns {
                removedLines.append(rowOfBlocks)
                for block in rowOfBlocks {
                    blockArray[block.column, block.row] = nil
                }
            }
        }

        if removedLines.count == 0 {
            return ([], [])
        }

        let pointsEarned = removedLines.count * PointsPerLine * level
        score += pointsEarned
        if score >= level * MaximumPoint {
            level += 1
            delegate?.gameDidLevelUp(gamelogic: self)
        }
        
        var fallenBlocks = Array<Array<Block>>()
        for column in 0..<NumColumns {
            var fallenBlocksArray = Array<Block>()
            for row in (1..<removedLines[0][0].row).reversed() {
                guard let block = blockArray[column, row] else {
                    continue
                }
                let newRow = row + removedLines.count
                block.row = newRow
                blockArray[column, row] = nil
                blockArray[column, newRow] = block
                fallenBlocksArray.append(block)
            }
            if fallenBlocksArray.count > 0 {
                fallenBlocks.append(fallenBlocksArray)
            }
        }
        return (removedLines, fallenBlocks)
    }
    
    

    
    
    
    
    func removeAllBlocks() -> Array<Array<Block>> {
        var allBlocks = Array<Array<Block>>()
        for row in 0..<NumRows {
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns {
                guard let block = blockArray[column, row] else {
                    continue
                }
                rowOfBlocks.append(block)
                blockArray[column, row] = nil
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }

}
