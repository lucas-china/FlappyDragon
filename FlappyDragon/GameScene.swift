//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Lucas Santana Brito on 11/01/20.
//  Copyright © 2020 lsb.br. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var floor: SKSpriteNode!
    private var intro: SKSpriteNode!
    private var player: SKSpriteNode!
    private var gameArea: CGFloat = 410.0
    
    override func didMove(to view: SKView) {
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
    }
    
    private func addFloor() {
        floor = SKSpriteNode(imageNamed: "floor")
        floor.zPosition = 2
        
        let height = size.height - gameArea - (floor.size.height / 2)
        floor.position = CGPoint(x: floor.size.width/2, y: height)
        addChild(floor)
    }
    
    private func addIntro() {
        intro = SKSpriteNode(imageNamed: "intro")
        intro.position = CGPoint(x: size.width/2, y: size.height - 210)
        intro.zPosition = 3
        addChild(intro)
    }
    
    private func addPlayer() {
        player = SKSpriteNode(imageNamed: "player1")
        player.position = CGPoint(x: 60, y: size.height - gameArea/2)
        player.zPosition = 4
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
