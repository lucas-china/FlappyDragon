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
    private var scoreLabel: SKLabelNode!
    
    private let gameArea: CGFloat = 410.0
    private let velocity: Double = 100.0
    
    private var gameStarted = false
    private var gameFinished = false
    private var gameRestarted = false
    private var score: Int = 0
    private let flyForce: CGFloat = 30.0
    
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
        moveFloor()
    }
    
    private func moveFloor() {
        let duration = Double(floor.size.width/2)/velocity
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
        let sequeceAction = SKAction.sequence([moveFloorAction, resetXAction])
        let repeatAction = SKAction.repeatForever(sequeceAction)
        floor.run(repeatAction)
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
        
        var playerTextures = [SKTexture]()
        
        for i in 1...4 {
            let playerTexture = SKTexture(imageNamed: "player\(i)")
            playerTextures.append(playerTexture)
        }
        
        let animationAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09)
        let repeatAction = SKAction.repeatForever(animationAction)
        player.run(repeatAction)
        
        addChild(player)
    }
    
    private func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 94
        scoreLabel.text = "\(score)"
        scoreLabel.alpha = 0.8
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 100)
        scoreLabel.zPosition = 5
        addChild(scoreLabel)
    }
    
    private func startGame() {
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
        
        gameStarted = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if !gameStarted {
                intro.removeFromParent()
                addScore()
                startGame()
            } else {
                player.physicsBody?.velocity = CGVector.zero
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let physicsBody = player.physicsBody else { return }
        
        let yVelocity = physicsBody.velocity.dy * 0.001 as CGFloat
        player.zRotation = yVelocity
    }
}
