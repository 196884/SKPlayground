//
//  PlayViewController.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import Foundation
import SpriteKit

class PlayViewController: UIViewController, BlockMoverDelegate {
    var gameOptions:GameOptions!
    var blocksGame:BlocksGame!
    var playScene:PlayScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blocksGame = BlocksGame(gameOptions: gameOptions!, delegate: self)
        //blocksGame.beginGame()
    }
    
    override func viewWillAppear(animated: Bool) {
        playScene      = PlayScene(size: CGSizeMake(768, 1024), gameOptions: gameOptions!)
        let skView     = view as SKView
        skView.presentScene(playScene)
        blocksGame.beginGame()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func gameDidBegin(blocksGame: BlocksGame) {
    }
    
    func gameDidEnd(blocksGame: BlocksGame) {
    }
    
    func addBlock(block: Block) {
        playScene.addBlockToScene(block) {}
    }
    
    func moveBlocks(movingBlocks: Array<Block>, transformedBlocks: Array<Block>, removedBlocks: Array<Block>, completion: () -> ()) {
        playScene.handleBlockMoves(movingBlocks, transformedBlocks: transformedBlocks, removedBlocks: removedBlocks, completion: completion)
        //scoreLabel.text = "\(blockMover.score)"
    }

    @IBAction func moveRight(sender: UISwipeGestureRecognizer) {
        blocksGame.moveRight()
    }
    
    @IBAction func moveLeft(sender: UISwipeGestureRecognizer) {
        blocksGame.moveLeft()
    }
    
    @IBAction func moveUp(sender: UISwipeGestureRecognizer) {
        blocksGame.moveUp()
    }
    
    @IBAction func moveDown(sender: UISwipeGestureRecognizer) {
        blocksGame.moveDown()
    }
}
