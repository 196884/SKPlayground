//
//  PlayScene.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import Foundation
import SpriteKit

class PlayScene : SKScene {
    let BackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    let GridColor       = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    let EmptyBlockColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
    let MoveDuration:NSTimeInterval = 0.4
    let FreeAtTop:CGFloat           = 100
    let OutBorderUnits:CGFloat      = 0.5
    let InBorderUnits:CGFloat       = 0.05
    let IntraBorderUnits:CGFloat    = 0.02
    var contentsCreated:Bool        = false
    var NumColumns:Int   = -1
    var NumRows:Int      = -1
    var UnitSize:CGFloat = -1
    var WOffset:CGFloat  = -1
    var HOffset:CGFloat  = -1
    
    init(size: CGSize, gameOptions: GameOptions) {
        super.init(size: size)
        NumColumns = gameOptions.NumColumns
        NumRows    = gameOptions.NumRows
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        if !contentsCreated {
            createSceneContents()
            contentsCreated = true
        }
    }
    
    func createSceneContents() {
        backgroundColor     = BackgroundColor
        position            = CGPoint(x: 0.0, y: 0.0)
        createGrid()
    }
    
    func getBlockShape(row: Int, column: Int) -> SKShapeNode {
        let squareShape = SKShapeNode(rect: CGRectMake(
            WOffset + (OutBorderUnits + InBorderUnits + IntraBorderUnits) * UnitSize,
            HOffset + (OutBorderUnits + InBorderUnits + IntraBorderUnits) * UnitSize,
            UnitSize * (1.0 - 2 * IntraBorderUnits),
            UnitSize * (1.0 - 2 * IntraBorderUnits)
        ), cornerRadius: 3)
        squareShape.position = CGPointMake(CGFloat(column) * UnitSize, CGFloat(row) * UnitSize)
        return squareShape
    }
    
    func createGrid() {
        let avWidth         = CGFloat(size.width)
        let avHeight        = CGFloat(size.height - FreeAtTop)
        
        let wUnits          = CGFloat(NumColumns) + 2 * ( OutBorderUnits + InBorderUnits )
        let hUnits          = CGFloat(NumRows) + 2 * ( OutBorderUnits + InBorderUnits )
        UnitSize            = min(avWidth / wUnits, avHeight / hUnits)
        WOffset             = ( avWidth  - wUnits * UnitSize ) / 2
        HOffset             = CGFloat(0) // ( avHeight - hUnits * unitSize ) / 2
        let gridShape       = SKShapeNode(rect: CGRectMake(
                WOffset + OutBorderUnits * UnitSize,
                HOffset + OutBorderUnits * UnitSize,
                ( 2 * InBorderUnits + CGFloat(NumColumns)) * UnitSize,
                ( 2 * InBorderUnits + CGFloat(NumRows)) * UnitSize
            ), cornerRadius: 3)
        gridShape.position  = position
        gridShape.fillColor = GridColor
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let blockShape = getBlockShape(row, column: column)
                blockShape.fillColor = EmptyBlockColor
                gridShape.addChild(blockShape)
            }
        }
        addChild(gridShape)
    }

    func addBlockToScene(block:Block, completion:() -> ()) {
        let blockShape  = getBlockShape(block.row, column: block.column)
        blockShape.fillColor = block.color.spriteColor
        blockShape.alpha     = 0.0
        addChild(blockShape)
        block.node           = blockShape
        
        // Animation
        let fadeInAction = SKAction.fadeAlphaTo(1, duration: 0.4)
        blockShape.runAction(fadeInAction, completion: completion)
    }
    
    func handleBlockMoves(movingBlocks: Array<Block>, transformedBlocks: Array<Block>, removedBlocks: Array<Block>, completion:() -> ()) {
        for block in movingBlocks {
            let shape  = block.node!
            let moveTo = CGPointMake(CGFloat(block.column) * UnitSize, CGFloat(block.row) * UnitSize)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: MoveDuration)
            moveToAction.timingMode = .EaseIn
            shape.runAction(moveToAction, completion: nil)
        }
        for block in transformedBlocks {
            // This is pretty painful... couldn't find a simpler way to transition the fillColor :(
            let shape    = block.node!
            let moveTo   = CGPointMake(CGFloat(block.column) * UnitSize, CGFloat(block.row) * UnitSize)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: MoveDuration)
            let oldColor = shape.fillColor
            let newColor = block.color.spriteColor
            var oldRed:CGFloat = 0
            var oldGreen:CGFloat = 0
            var oldBlue:CGFloat = 0
            var oldAlpha:CGFloat = 0
            var newRed:CGFloat = 0
            var newGreen:CGFloat = 0
            var newBlue:CGFloat = 0
            var newAlpha:CGFloat = 0
            oldColor.getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)
            newColor.getRed(&newRed, green: &newGreen, blue: &newBlue, alpha: &newAlpha)
            
            moveToAction.timingMode = .EaseIn
            func customAction(node:SKNode!, elapsedTime:CGFloat) -> () {
                if let shapeNode = node as? SKShapeNode {
                    let w        = elapsedTime / CGFloat(MoveDuration)
                    let newColor = block.color.spriteColor
                    shapeNode.fillColor = UIColor(
                        red:   w * newRed   + (1-w) * oldRed,
                        green: w * newGreen + (1-w) * oldGreen,
                        blue:  w * newBlue  + (1-w) * oldBlue,
                        alpha: w * newAlpha + (1-w) * oldAlpha)
                }
            }
            let colorAction:SKAction  = SKAction.customActionWithDuration(MoveDuration, actionBlock: customAction)
            shape.runAction(SKAction.group([
                moveToAction,
                colorAction
            ]))
        }
        for block in removedBlocks {
            let shape    = block.node!
            let moveTo   = CGPointMake(CGFloat(block.column) * UnitSize, CGFloat(block.row) * UnitSize)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: MoveDuration)
            moveToAction.timingMode = .EaseIn
            shape.runAction(moveToAction, completion: nil)
            shape.runAction(SKAction.sequence([
                SKAction.group([moveToAction, SKAction.fadeOutWithDuration(MoveDuration)]),
                SKAction.removeFromParent()
            ]))
        }
        runAction(SKAction.waitForDuration(MoveDuration), completion: completion)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
}
