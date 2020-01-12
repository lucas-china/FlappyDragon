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
    private var timer: Timer!
    
    private let playerCategory: UInt32 = 1
    private let enemyCategory: UInt32 = 2
    private let scoreCategory: UInt32 = 4
    
    weak var gameViewController: GameViewController?
    
    let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
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
        
        addInvisebleFloor()
        addInvisebleRoof()
    }
    
    private func addInvisebleFloor() {
        let invisibleFloor = SKNode()
        invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        invisibleFloor.physicsBody?.isDynamic = false
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        
        invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea)
        invisibleFloor.zPosition = 2
        addChild(invisibleFloor)
    }
    
    private func addInvisebleRoof() {
           let invisibleRoof = SKNode()
           invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
           invisibleRoof.physicsBody?.isDynamic = false
           invisibleRoof.position = CGPoint(x: size.width/2, y: size.height )
           invisibleRoof.zPosition = 2
           addChild(invisibleRoof)
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
        
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = scoreCategory
        player.physicsBody?.collisionBitMask = enemyCategory
        
        gameStarted = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (timer) in
            self.spawnEnemies()
        }
    }
    
    private func spawnEnemies() {
        let initialPosition = CGFloat(arc4random_uniform(132) + 74)
        let enemyNumber = Int(arc4random_uniform(4) + 1)
        let enemiesDistance = self.player.size.height * 2.5
        
        // ENEMY TOP
        let enemyTop = SKSpriteNode(imageNamed: "enemytop\(enemyNumber)")
        let enemyWidth = enemyTop.size.width
        let enemyHeight = enemyTop.size.height
        
        enemyTop.position = CGPoint(x: size.width + enemyWidth/2, y: size.height - initialPosition + enemyHeight/2)
        enemyTop.zPosition = 1
        enemyTop.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
        enemyTop.physicsBody?.isDynamic = false
        enemyTop.physicsBody?.categoryBitMask = enemyCategory
        enemyTop.physicsBody?.contactTestBitMask = playerCategory
        
        // ENEMY BOTTOM
        let enemyBottom = SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)")
        enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyHeight - enemiesDistance)
        enemyBottom.zPosition = 1
        enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyBottom.size)
        enemyBottom.physicsBody?.isDynamic = false
        enemyBottom.physicsBody?.categoryBitMask = enemyCategory
        enemyBottom.physicsBody?.contactTestBitMask = playerCategory
        
        // LASER
        let laser = SKNode()
        laser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2, y: enemyTop.position.y - enemyHeight/2 - enemiesDistance/2)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemiesDistance))
        laser.physicsBody?.isDynamic = false
        laser.physicsBody?.categoryBitMask = scoreCategory
        
        // ACTIONS ENEMIES
        let distance = size.width + enemyWidth
        let duration = Double(distance)/velocity
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        enemyTop.run(sequenceAction)
        enemyBottom.run(sequenceAction)
        laser.run(sequenceAction)
        
        addChild(enemyTop)
        addChild(enemyBottom)
        addChild(laser)
        
    }
    
    private func gameOver() {
        timer.invalidate()
        player.zRotation = 0
        player.texture = SKTexture(imageNamed: "playerDead")
        for node in children {
            node.removeAllActions()
        }
        player.physicsBody?.isDynamic = false
        gameFinished = true
        gameStarted = false
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.fontColor = .red
            gameOverLabel.fontSize = 40
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            gameOverLabel.zPosition = 5
            self.addChild(gameOverLabel)
            self.gameRestarted = true
        }
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
        } else {
            if gameRestarted {
                gameRestarted = false
                gameViewController?.presentScene()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let physicsBody = player.physicsBody else { return }
        
        let yVelocity = physicsBody.velocity.dy * 0.001 as CGFloat
        player.zRotation = yVelocity
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStarted {
            if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
                score += 1
                scoreLabel.text = "\(score)"
                run(scoreSound)
                
            } else if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory {
                gameOver()
                run(gameOverSound)
            }
        }
    }
}
