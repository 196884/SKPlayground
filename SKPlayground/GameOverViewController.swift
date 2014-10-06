//
//  GameOverViewController.swift
//  SKPlayground
//
//  Created by Regis Dupont on 10/5/14.
//  Copyright (c) 2014 Regis Dupont. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverViewController: UIViewController {
    var gameOptions:GameOptions!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        view.backgroundColor    = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        gameOverLabel.textColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        gameOverLabel.layer.cornerRadius  = 20
        gameOverLabel.layer.masksToBounds = true
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
