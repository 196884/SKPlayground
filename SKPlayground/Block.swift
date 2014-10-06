//
//  Block.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import Foundation
import SpriteKit

let NumberOfColors: UInt32 = 6
let BaseAlpha: CGFloat = 0.7

enum BlockColor: Int {
    case Color0 = 0, Color1, Color2, Color3, Color4, Color5
    
    var spriteColor: UIColor {
        switch self {
        case .Color0:
            return UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: BaseAlpha)
        case .Color1:
            return UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: BaseAlpha)
        case .Color2:
            return UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: BaseAlpha)
        case .Color3:
            return UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: BaseAlpha)
        case .Color4:
            return UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: BaseAlpha)
        case .Color5:
            return UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: BaseAlpha)
        default:
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: BaseAlpha)
        }
    }
    
    static func random() -> BlockColor {
        return BlockColor.fromRaw(Int(arc4random_uniform(NumberOfColors)))!
    }
    
    // Returns nil if the 2 colors cannot be combined
    static func combine(color1: BlockColor, color2: BlockColor) -> BlockColor? {
        if color1 != color2 {
            return nil
        } else {
            return BlockColor.fromRaw((color1.toRaw() + 1) % Int(NumberOfColors))
        }
    }
}

class Block {
    var row:     Int
    var column:  Int
    var color:   BlockColor
    var node:    SKShapeNode?
    
    init(row: Int, column: Int) {
        self.row    = row
        self.column = column
        self.color  = BlockColor.random()
    }
    
    func combineWith(block: Block) -> Bool {
        if let newColor = BlockColor.combine(color, color2: block.color) {
            self.color = newColor
            return true
        } else {
            return false
        }
    }
    
    func combineableWith(block: Block) -> Bool {
        if let newColor = BlockColor.combine(color, color2: block.color) {
            return true
        } else {
            return false
        }
    }
}
