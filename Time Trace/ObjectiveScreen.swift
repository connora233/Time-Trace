//
//  ObjectiveScreen.swift
//  Time Trace
//
//  Created by Ashley Granitto on 8/14/19.
//  Copyright © 2019 TTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObjectiveScreen: SKScene {
    
    //--------------------------------------VARIABLE DECLARATION--------------------------------------
    
    // Variable declaration for general game constants.
    private var screenWidth : CGFloat = CGFloat(UIScreen.main.bounds.width)
    private var screenHeight : CGFloat = CGFloat(UIScreen.main.bounds.height)
    
    // Variable declaration for theme implementation.
    private var tempTheme : String? = ""
    private var colorTheme : String = "RAINBOW"
    private var buttonColor : UIColor = UIColor.white
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Creates a fading circle shape node to track the user's touch movements. Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        
        let returnButton = SKShapeNode()
        returnButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -550, width: 400, height: 200), cornerRadius: 30).cgPath
        returnButton.zPosition = 1
        returnButton.fillColor = buttonColor
        returnButton.strokeColor = buttonColor
        returnButton.alpha = 0.25
        
        addChild(returnButton)
    }
    
    // Adjusts the background and button colors based upon the theme selected in the settings.
    func adjustTheme() {
        let userDefaults = Foundation.UserDefaults.standard
        let cTheme = userDefaults.string(forKey: "Theme")
        tempTheme = cTheme
        if(tempTheme == nil) {
            colorTheme = "RAINBOW"
            backgroundColor = UIColor(red: 0.6667, green: 0.9529, blue: 1, alpha: 1.0)
        }
        else {
            colorTheme = cTheme!
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
    
    // ------------------------------------TOUCH-RELATED FUNCTIONS------------------------------------
    
    // Transfers the user to the menu screen after the user presses the return button.
    func touchDown(atPoint pos : CGPoint) {
        if(pos.x > -200 && pos.x < 200 && pos.y > -550 && pos.y < -350) {
            let startScreen = StartScreen(fileNamed: "StartScreen")
            startScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(startScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
    }
    
    // Registers the point of contact where the user first touches the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
