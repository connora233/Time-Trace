//
//  GameOverScreen.swift
//  Time Trace
//
//  Created by Ashley Granitto on 8/12/19.
//  Copyright © 2019 TTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScreen: SKScene {
    
    // Variable for radius of the corner's of rectangles used to make buttons.
    private var currentRadius : CGFloat = 50
    var gameScore : String = ""
    var highScore : String = ""
    private var scoreLabel : SKLabelNode?
    private var highScoreLabel: SKLabelNode?
    private var menuButton = SKShapeNode()
    private var newGameButton = SKShapeNode()
    
    // Variables to store the different screens to be referrenced when buttons are hit.
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        let userDefaults = Foundation.UserDefaults.standard
        let currScore = userDefaults.string(forKey: "Score")
        let hScore = userDefaults.string(forKey: "HighScore")
        gameScore = currScore!
        highScore = hScore!
        menuButtonInitializer()
        newGameButtonInitializer()
        scoreLabelInitializer(score: gameScore)
        highScoreLabelInitializer(highScore: highScore)
        
    }
    
    func menuButtonInitializer() {
        menuButton.path = UIBezierPath(roundedRect: CGRect(x: -150, y: -100, width: 300, height: 150), cornerRadius: currentRadius).cgPath
        menuButton.fillColor = UIColor.lightGray
        menuButton.strokeColor = UIColor.lightGray
        menuButton.alpha = 0.25
        addChild(menuButton)
    }
    
    func newGameButtonInitializer() {
        newGameButton.path = UIBezierPath(roundedRect: CGRect(x: -150, y: -350, width: 300, height: 150), cornerRadius: currentRadius).cgPath
        newGameButton.fillColor = UIColor.lightGray
        newGameButton.strokeColor = UIColor.lightGray
        newGameButton.alpha = 0.25
        addChild(newGameButton)
    }
    
    // Initializes the score label.
    func scoreLabelInitializer(score: String){
        scoreLabel = SKLabelNode(fontNamed: "Futura Medium")
        scoreLabel?.text = score
        scoreLabel?.fontSize = 98
        scoreLabel?.fontColor = UIColor.black
        scoreLabel?.position = CGPoint(x: 0, y: 400)
        self.addChild(scoreLabel!)
    }
    
    func highScoreLabelInitializer(highScore: String){
        highScoreLabel = SKLabelNode(fontNamed: "Futura Medium")
        highScoreLabel?.text = highScore
        highScoreLabel?.fontSize = 98
        highScoreLabel?.fontColor = UIColor.black
        highScoreLabel?.position = CGPoint(x: 0, y: 150)
        self.addChild(highScoreLabel!)
    }
    
    //------------------------------------TOUCH-RELATED FUCNTIONS------------------------------------
    func touchDown(atPoint pos : CGPoint) {
        if(pos.x > -150 && pos.x < 150 && pos.y > -350 && pos.y < -200) {
            let gameScene = GameScene(fileNamed: "GameScene")
            gameScene!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene!, transition: SKTransition.flipHorizontal(withDuration: 1.0))
        }
        if(pos.x > -150 && pos.x < 150 && pos.y > -100 && pos.y < 50) {
            let startScreen = StartScreen(fileNamed: "StartScreen")
            startScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(startScreen!, transition: SKTransition.flipHorizontal(withDuration: 1.0))
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
}
