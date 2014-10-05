//
//  BlocksGame.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import Foundation

protocol BlockMoverDelegate {
    func gameDidBegin(blocksGame: BlocksGame)
    func gameDidEnd(blocksGame: BlocksGame)
    func addBlock(block: Block)
    func moveBlocks(movingBlocks: Array<Block>, transformedBlocks: Array<Block>, removedBlocks: Array<Block>, completion: () -> ())
}

class BlocksGame {
    var NumColumns: Int
    var NumRows:    Int
    var blockArray: Array2D<Block>
    var score:      Int
    var delegate:   BlockMoverDelegate?
    
    init(gameOptions: GameOptions, delegate: BlockMoverDelegate)
    {
        self.delegate = delegate
        NumColumns    = gameOptions.NumColumns
        NumRows       = gameOptions.NumRows
        blockArray    = Array2D<Block>(columns: NumColumns, rows:NumRows)
        score         = 0
    }
    
    func beginGame() {
        delegate?.gameDidBegin(self)
        newBlock()
    }
    
    func newBlock() {
        // We try to return a random free position
        var freePositions = Array<(column:Int, row:Int)>()
        for column in 0..<NumColumns {
            for row in 0..<NumRows {
                if blockArray[column, row] == nil {
                    freePositions.append((column: column, row: row))
                }
            }
        }
        let nbFreePositions = UInt32(freePositions.count)
        if 0 == nbFreePositions {
            // No more free positions: the game is finished!
            endGame()
        } else {
            let freePositionIdx = Int(arc4random_uniform(nbFreePositions))
            let position        = freePositions[freePositionIdx]
            var block = Block(row: position.row, column: position.column)
            blockArray[position.column, position.row] = block
            delegate?.addBlock(block)
        }
    }
    
    func endGame() {
        NSLog("Game did end")
        delegate?.gameDidEnd(self)
        beginGame()
    }
    
    func updateScore(nbTransformed: Int) {
        if 0 == nbTransformed {
            return ()
        }
        var points:Int = 1
        var rem:Int = nbTransformed
        while rem > 1 {
            points *= 2
            --rem
        }
        score += points
    }
    
    func moveLeft() -> () {
        var movingBlocks      = Array<Block>()
        var transformedBlocks = Array<Block>()
        var removedBlocks     = Array<Block>()
        for row in 0..<NumRows {
            var dstIdx      = -1
            var combineable = false
            var dstMoved    = false // whether the block currently at dstIdx (if any!) has already been moved
            
            for srcIdx in 0..<NumColumns {
                // At this point, we assume that the block at [dstIdx, row] (if there is one!)
                // hasn't been put in any output yet.
                
                if var block = blockArray[srcIdx, row] {
                    // Can the block be combined with the previous one? (if there's one...)
                    if combineable && blockArray[dstIdx, row]!.combineableWith(block) {
                        blockArray[srcIdx, row] = nil
                        block.column = dstIdx
                        removedBlocks.append(block)
                        transformedBlocks.append(blockArray[dstIdx, row]!)
                        combineable = false
                        dstMoved    = false
                    } else {
                        if dstMoved {
                            movingBlocks.append(blockArray[dstIdx, row]!)
                        }
                        ++dstIdx
                        if dstIdx < srcIdx {
                            // We can slide it, for now
                            dstMoved    = true
                            blockArray[srcIdx, row] = nil
                            block.column            = dstIdx
                            blockArray[dstIdx, row] = block
                        } else {
                            // This block is not moving...
                            dstMoved    = false
                        }
                        combineable = true
                    }
                }
            }
            if dstMoved {
                movingBlocks.append(blockArray[dstIdx, row]!)
            }
        }
        updateScore(transformedBlocks.count)
        if movingBlocks.count + transformedBlocks.count + removedBlocks.count > 0 {
            delegate?.moveBlocks(movingBlocks, transformedBlocks: transformedBlocks, removedBlocks: removedBlocks, completion: newBlock)
        }
    }
    
    func moveRight() -> () {
        var movingBlocks      = Array<Block>()
        var transformedBlocks = Array<Block>()
        var removedBlocks     = Array<Block>()
        for row in 0..<NumRows {
            var dstIdx      = NumColumns
            var combineable = false
            var dstMoved    = false // whether the block currently at dstIdx (if any!) has already been moved
            
            for auxIdx in 0..<NumColumns {
                // At this point, we assume that the block at [dstIdx, row] (if there is one!)
                // hasn't been put in any output yet.
                let srcIdx = NumColumns - 1 - auxIdx
                if var block = blockArray[srcIdx, row] {
                    // Can the block be combined with the previous one? (if there's one...)
                    if combineable && blockArray[dstIdx, row]!.combineableWith(block) {
                        blockArray[srcIdx, row] = nil
                        block.column = dstIdx
                        removedBlocks.append(block)
                        transformedBlocks.append(blockArray[dstIdx, row]!)
                        combineable = false
                        dstMoved    = false
                    } else {
                        if dstMoved {
                            movingBlocks.append(blockArray[dstIdx, row]!)
                        }
                        --dstIdx
                        if dstIdx > srcIdx {
                            // We can slide it, for now
                            dstMoved    = true
                            blockArray[srcIdx, row] = nil
                            block.column            = dstIdx
                            blockArray[dstIdx, row] = block
                        } else {
                            // This block is not moving...
                            dstMoved    = false
                        }
                        combineable = true
                    }
                }
            }
            if dstMoved {
                movingBlocks.append(blockArray[dstIdx, row]!)
            }
        }
        updateScore(transformedBlocks.count)
        if movingBlocks.count + transformedBlocks.count + removedBlocks.count > 0 {
            delegate?.moveBlocks(movingBlocks, transformedBlocks: transformedBlocks, removedBlocks: removedBlocks, completion: newBlock)
        }
    }
    
    func moveDown() -> () {
        var movingBlocks      = Array<Block>()
        var transformedBlocks = Array<Block>()
        var removedBlocks     = Array<Block>()
        for column in 0..<NumColumns {
            var dstIdx      = -1
            var combineable = false
            var dstMoved    = false // whether the block currently at dstIdx (if any!) has already been moved
            
            for srcIdx in 0..<NumRows {
                // At this point, we assume that the block at [dstIdx, row] (if there is one!)
                // hasn't been put in any output yet.
                
                if var block = blockArray[column, srcIdx] {
                    // Can the block be combined with the previous one? (if there's one...)
                    if combineable && blockArray[column, dstIdx]!.combineableWith(block) {
                        blockArray[column, srcIdx] = nil
                        block.row = dstIdx
                        removedBlocks.append(block)
                        transformedBlocks.append(blockArray[column, dstIdx]!)
                        combineable = false
                        dstMoved    = false
                    } else {
                        if dstMoved {
                            movingBlocks.append(blockArray[column, dstIdx]!)
                        }
                        ++dstIdx
                        if dstIdx < srcIdx {
                            // We can slide it, for now
                            dstMoved    = true
                            blockArray[column, srcIdx] = nil
                            block.row                  = dstIdx
                            blockArray[column, dstIdx] = block
                        } else {
                            // This block is not moving...
                            dstMoved    = false
                        }
                        combineable = true
                    }
                }
            }
            if dstMoved {
                movingBlocks.append(blockArray[column, dstIdx]!)
            }
        }
        updateScore(transformedBlocks.count)
        if movingBlocks.count + transformedBlocks.count + removedBlocks.count > 0 {
            delegate?.moveBlocks(movingBlocks, transformedBlocks: transformedBlocks, removedBlocks: removedBlocks, completion: newBlock)
        }
    }
    
    func moveUp() -> () {
        var movingBlocks      = Array<Block>()
        var transformedBlocks = Array<Block>()
        var removedBlocks     = Array<Block>()
        for column in 0..<NumColumns {
            var dstIdx      = NumRows
            var combineable = false
            var dstMoved    = false // whether the block currently at dstIdx (if any!) has already been moved
            
            for auxIdx in 0..<NumRows {
                // At this point, we assume that the block at [dstIdx, row] (if there is one!)
                // hasn't been put in any output yet.
                let srcIdx = NumRows - 1 - auxIdx
                
                if var block = blockArray[column, srcIdx] {
                    // Can the block be combined with the previous one? (if there's one...)
                    if combineable && blockArray[column, dstIdx]!.combineableWith(block) {
                        blockArray[column, srcIdx] = nil
                        block.row = dstIdx
                        removedBlocks.append(block)
                        transformedBlocks.append(blockArray[column, dstIdx]!)
                        combineable = false
                        dstMoved    = false
                    } else {
                        if dstMoved {
                            movingBlocks.append(blockArray[column, dstIdx]!)
                        }
                        --dstIdx
                        if dstIdx > srcIdx {
                            // We can slide it, for now
                            dstMoved    = true
                            blockArray[column, srcIdx] = nil
                            block.row                  = dstIdx
                            blockArray[column, dstIdx] = block
                        } else {
                            // This block is not moving...
                            dstMoved    = false
                        }
                        combineable = true
                    }
                }
            }
            if dstMoved {
                movingBlocks.append(blockArray[column, dstIdx]!)
            }
        }
        updateScore(transformedBlocks.count)
        if movingBlocks.count + transformedBlocks.count + removedBlocks.count > 0 {
            delegate?.moveBlocks(movingBlocks, transformedBlocks: transformedBlocks, removedBlocks: removedBlocks, completion: newBlock)
        }
    }
}