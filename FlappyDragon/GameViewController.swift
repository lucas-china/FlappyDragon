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
import AVFoundation

class GameViewController: UIViewController {
    
    var stage: SKView!
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = view as? SKView else { return }
        stage = data
        stage.ignoresSiblingOrder = true
        
        presentScene()
        playMusic()
    }
    
    func presentScene() {
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.gameViewController = self
        scene.scaleMode = .aspectFill
        stage.presentScene(scene, transition: .doorway(withDuration: 0.5))
    }
    
    private func playMusic() {
        if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            musicPlayer = try? AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.volume = 0.4
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
