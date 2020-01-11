//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Lucas Santana Brito on 11/01/20.
//  Copyright © 2020 lsb.br. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var stage: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = view as? SKView else { return }
        stage = data
        stage.ignoresSiblingOrder = true
        
        presentScene()
    }
    
    private func presentScene() {
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.scaleMode = .aspectFill
        stage.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
