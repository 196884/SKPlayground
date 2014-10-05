//
//  IntroViewController.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import UIKit
import SpriteKit

class IntroViewController: UIViewController {
    var gameOptions = GameOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as SKView
    }
    
    override func viewWillAppear(animated: Bool) {
        let introScene = IntroScene(size: CGSizeMake(768, 1024))
        let skView     = view as SKView
        skView.presentScene(introScene)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? PlayViewController {
            dest.gameOptions = gameOptions
        }
    }
}
