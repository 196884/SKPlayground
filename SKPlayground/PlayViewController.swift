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
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blocksGame = BlocksGame(gameOptions: gameOptions!, delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        playScene      = PlayScene(size: CGSizeMake(768, 1024), gameOptions: gameOptions!)
        let skView     = view as SKView
        skView.showsFPS       = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.presentScene(playScene)
        blocksGame.beginGame()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func gameDidBegin(blocksGame: BlocksGame) {
        scoreLabel.text = "\(blocksGame.score)"
    }
    
    func gameDidEnd(blocksGame: BlocksGame) {
        playScene.runAction(SKAction.waitForDuration(1.0))
        performSegueWithIdentifier("GameOverSegue", sender: self)
    }
    
    func addBlock(block: Block) {
        playScene.addBlockToScene(block) {}
    }
    
    func moveBlocks(movingBlocks: Array<Block>, transformedBlocks: Array<Block>, removedBlocks: Array<Block>, completion: () -> ()) {
        playScene.handleBlockMoves(movingBlocks, transformedBlocks: transformedBlocks, removedBlocks: removedBlocks, completion: completion)
        scoreLabel.text = "\(blocksGame.score)"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? GameOverViewController {
            dest.gameOptions = gameOptions
        }
    }
}
