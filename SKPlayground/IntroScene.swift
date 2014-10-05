//
//  IntroScene.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import Foundation
import SpriteKit

class IntroScene : SKScene {
    var contentsCreated:Bool = false
    var gameOptions          = GameOptions()
    
    override func didMoveToView(view: SKView) {
        if !contentsCreated {
            createSceneContents()
            contentsCreated = true
        }
    }
    
    func createSceneContents() {
        backgroundColor     = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        let titleNode       = SKLabelNode(fontNamed:"AppleSDGothicNeo-Medium")
        titleNode.name      = "titleNode"
        titleNode.text      = "Blocks!"
        titleNode.fontSize  = 70
        // we want to be at 70% from the bottom:
        titleNode.position  = CGPointMake(CGRectGetMidX(frame), 0.3 * CGRectGetMinY(frame) + 0.7 * CGRectGetMaxY(frame))
        titleNode.fontColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        addChild(titleNode)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
}
