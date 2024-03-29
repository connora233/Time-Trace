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
    
    //--------------------------------------VARIABLE DECLARATION--------------------------------------
    
    // Variable declaration for general game constants.
    private var screenWidth : CGFloat = CGFloat(UIScreen.main.bounds.width)
    private var screenHeight : CGFloat = CGFloat(UIScreen.main.bounds.height)
    
    // Variable declaration for theme implementation.
    private var tempTheme : String? = ""
    private var colorTheme : String = "RAINBOW"
    private var buttonColor : UIColor = UIColor.white
    
    // Variable declaration for initialization.
    private var currentRadius : CGFloat = 50
    var gameScore : String = ""
    var highScore : String = ""
    private var scoreLabel : SKLabelNode?
    private var highScoreLabel: SKLabelNode?
    
    // Variable declaration for screen initialization.
    private var yCordArray : Array<CGFloat> = [-300, -550]
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    override func didMove(to view: SKView) {
        adjustTheme()
        let userDefaults = Foundation.UserDefaults.standard
        let currScore = userDefaults.string(forKey: "Score")
        let hScore = userDefaults.string(forKey: "HighScore")
        gameScore = currScore!
        highScore = hScore!
        for yCord in yCordArray {
            drawButton(yCord: yCord)
        }
        scoreLabelInitializer(score: gameScore)
        highScoreLabelInitializer(highScore: highScore)
    }
    
    // Adjusts the background and button colors based upon the theme selected in the settings.
    func adjustTheme() {
        let userDefaults = Foundation.UserDefaults.standard
        tempTheme = userDefaults.string(forKey: "Theme")
        if(tempTheme == nil) {
            colorTheme = "RAINBOW"
            backgroundColor = UIColor(red: 0.6667, green: 0.9529, blue: 1, alpha: 1.0)
        }
        else {
            colorTheme = tempTheme!
        }
        if colorTheme == "RAINBOW" {
            backgroundColor = UIColor(red: 0.6667, green: 0.9529, blue: 1, alpha: 1.0)
        }
        if colorTheme == "SPACE" {
            let background = SKSpriteNode(imageNamed: "space")
            background.position = CGPoint(x: 0, y: 0)
            background.zPosition = 0
            background.scale(to: CGSize(width: screenWidth * 2, height: screenHeight * 2))
            addChild(background)
        }
        if colorTheme == "SUNSET" {
            let background = SKSpriteNode(imageNamed: "sunset")
            background.position = CGPoint(x: 0, y: 0)
            background.zPosition = 0
            background.scale(to: CGSize(width: screenWidth * 2, height: screenHeight * 2))
            addChild(background)
        }
    }
    
    // Initializes the score label.
    func scoreLabelInitializer(score: String){
        scoreLabel = SKLabelNode(fontNamed: "Futura Medium")
        scoreLabel?.text = score
        scoreLabel?.fontSize = 98
        scoreLabel?.fontColor = UIColor.black
        scoreLabel?.position = CGPoint(x: 0, y: 400)
        scoreLabel?.zPosition = 1
        self.addChild(scoreLabel!)
    }
    
    // Initializes the high score label.
    func highScoreLabelInitializer(highScore: String){
        highScoreLabel = SKLabelNode(fontNamed: "Futura Medium")
        highScoreLabel?.text = highScore
        highScoreLabel?.fontSize = 98
        highScoreLabel?.fontColor = UIColor.black
        highScoreLabel?.position = CGPoint(x: 0, y: 150)
        highScoreLabel?.zPosition = 1
        self.addChild(highScoreLabel!)
    }
    
    //---------------------------------------DRAWING FUCNTIONS---------------------------------------
    
    // Draws a pre-stylized button at a specified y-coordinate.
    func drawButton(yCord: CGFloat){
        let button = SKShapeNode()
        button.path = UIBezierPath(roundedRect: CGRect(x: -200, y: yCord, width: 400, height: 200), cornerRadius: currentRadius).cgPath
        button.zPosition = 1
        button.fillColor = buttonColor
        button.strokeColor = buttonColor
        button.alpha = 0.25
        addChild(button)
    }
    
    //------------------------------------TOUCH-RELATED FUCNTIONS------------------------------------
    
    // Transfers the user to the proper screen after the user presses a button.
    func touchDown(atPoint pos : CGPoint) {
        if(pos.x > -200 && pos.x < 200 && pos.y > -300 && pos.y < -100) {
            let gameScene = ObjectiveScreen(fileNamed: "GameScene")
            gameScene!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        
        if(pos.x > -200 && pos.x < 200 && pos.y > -550 && pos.y < -350) {
            let startScreen = SettingsScreen(fileNamed: "StartScreen")
            startScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(startScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
    }
    
    // Registers the point of contact where the user first touches the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
