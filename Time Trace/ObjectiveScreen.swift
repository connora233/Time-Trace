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
    private var buttonColor : UIColor = UIColor.lightGray
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Creates a fading circle shape node to track the user's touch movements. Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        
        let returnButton = SKShapeNode()
        returnButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -550, width: 400, height: 200), cornerRadius: 30).cgPath
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
        }
        else {
            colorTheme = cTheme!
        }
        if colorTheme == "RAINBOW" {
            backgroundColor = UIColor.white
            buttonColor = UIColor.lightGray
        }
        if colorTheme == "COOL" {
            backgroundColor = UIColor(red: 0, green: 0.6588, blue: 0.9882, alpha: 1.0)
            buttonColor = UIColor.white
        }
        if colorTheme == "WARM" {
            backgroundColor = UIColor(red: 0.9373, green: 0.6706, blue: 0, alpha: 1.0)
            buttonColor = UIColor.white
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
