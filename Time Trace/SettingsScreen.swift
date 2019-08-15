//
//  SettingsScreen.swift
//  Time Trace
//
//  Created by Ashley Granitto on 8/14/19.
//  Copyright © 2019 TTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class SettingsScreen: SKScene {
    
    private var colorTheme : String = "RAINBOW"
    private var buttonColor : UIColor = UIColor.lightGray
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Creates a fading circle shape node to track the user's touch movements. Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        
        let returnButton = SKShapeNode()
        returnButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -550, width: 400, height: 200), cornerRadius: 30).cgPath
        returnButton.fillColor = UIColor.lightGray
        returnButton.strokeColor = UIColor.lightGray
        returnButton.alpha = 0.25
        addChild(returnButton)
        
        let option1Button = SKShapeNode()
        option1Button.path = UIBezierPath(roundedRect: CGRect(x: -200, y: 300, width: 400, height: 100), cornerRadius: 30).cgPath
        option1Button.fillColor = UIColor.lightGray
        option1Button.strokeColor = UIColor.lightGray
        option1Button.alpha = 0.25
        addChild(option1Button)
        
        let option2Button = SKShapeNode()
        option2Button.path = UIBezierPath(roundedRect: CGRect(x: -200, y: 0, width: 400, height: 100), cornerRadius: 30).cgPath
        option2Button.fillColor = UIColor.lightGray
        option2Button.strokeColor = UIColor.lightGray
        option2Button.alpha = 0.25
        addChild(option2Button)
        
        let option3Button = SKShapeNode()
        option3Button.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -300, width: 400, height: 100), cornerRadius: 30).cgPath
        option3Button.fillColor = UIColor.lightGray
        option3Button.strokeColor = UIColor.lightGray
        option3Button.alpha = 0.25
        addChild(option3Button)
    }
    
    func adjustTheme() {
        let userDefaults = Foundation.UserDefaults.standard
        colorTheme = userDefaults.string(forKey: "Theme")!
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
    
    func touchDown(atPoint pos : CGPoint) {
        
        if(pos.x > -200 && pos.x < 200 && pos.y > -550 && pos.y < -350) {
            let startScreen = StartScreen(fileNamed: "StartScreen")
            startScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(startScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        
        if(pos.x > -200 && pos.x < 200 && pos.y > 300 && pos.y < 400) {
            let colorTheme = "RAINBOW"
            backgroundColor = UIColor.white
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(colorTheme, forKey: "Theme")
        }
        
        if(pos.x > -200 && pos.x < 200 && pos.y > 0 && pos.y < 100) {
            let colorTheme = "COOL"
            backgroundColor = UIColor(red: 0, green: 0.6588, blue: 0.9882, alpha: 1.0)
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(colorTheme, forKey: "Theme")
        }
        
        if(pos.x > -200 && pos.x < 200 && pos.y > -300 && pos.y < -200) {
            let colorTheme = "WARM"
            backgroundColor = UIColor(red: 0.9373, green: 0.6706, blue: 0, alpha: 1.0)
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(colorTheme, forKey: "Theme")
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

