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
    
    //--------------------------------------VARIABLE DECLARATION--------------------------------------
    
    // Variable declaration for general game constants.
    private var screenWidth : CGFloat = CGFloat(UIScreen.main.bounds.width)
    private var screenHeight : CGFloat = CGFloat(UIScreen.main.bounds.height)
    
    // Variable declaration for theme implementation.
    private var tempTheme : String? = ""
    private var colorTheme : String = "RAINBOW"
    private var colorArrayCounter : Int = 0
    private var colorArray1 : Array<UIColor> = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    private var colorArray2 : Array<UIColor> = [UIColor(red: 0, green: 0.3961, blue: 0.6, alpha: 1.0), UIColor(red: 0, green: 0.4549, blue: 0.4784, alpha: 1.0), UIColor.white, UIColor(red: 0.8235, green: 0.7176, blue: 0.9686, alpha: 1.0), UIColor(red: 0.6, green: 0.3176, blue: 0.9686, alpha: 1.0), UIColor(red: 0.4235, green: 0.0078, blue: 0.9686, alpha: 1.0)]
    private var colorArray3 : Array<UIColor> = [UIColor(red: 0, green: 0.5804, blue: 0.698, alpha: 1.0), UIColor(red: 0, green: 0.7176, blue: 0.8784, alpha: 1.0), UIColor(red: 0.9294, green: 0.451, blue: 0.4157, alpha: 1.0), UIColor(red: 0.9373, green: 0.702, blue: 0.1098, alpha: 1.0), UIColor(red: 0.9373, green: 0.8588, blue: 0.3451, alpha: 1.0), UIColor(red: 0.9765, green: 0.9412, blue: 0.4392, alpha: 1.0)]
    
    // Variable declaration for button-related visuals.
    private var buttonPress : Int = 0
    private var buttonPressTracker : Int = 0
    private var buttonColor : UIColor = UIColor.lightGray
    private var buttonPressColor : UIColor = UIColor.darkGray
    private var buttonArray : Array<SKShapeNode> = []
    
    // Variable declaration for screen initialization.
    private var buttonStatsCordArray : Array<Array<Int>> = [[300, 100], [0, 100], [-300, 100], [-550, 200]]
    private var xCordColor : Array<CGFloat> = [-200, -133.33, -66.66, 0, 66.66, 133.33]
    private var yCordColor : Array<CGFloat> = [425, 125, -175]
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Creates a fading circle shape node to track the user's touch movements. Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        buttonReset()
        var count = 0
        let colorArray = [colorArray1, colorArray2, colorArray3]
        for yCord in yCordColor{
            drawColorSamples(yCord: yCord, colors: colorArray[count])
            count += 1
        }
    }
    
    // Adjusts the highlighted button based upon the selected theme.
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
            buttonPress = 0
        }
        if colorTheme == "SPACE" {
            buttonPress = 1
        }
        if colorTheme == "SUNSET" {
            buttonPress = 2
        }
    }
    
    //---------------------------------------DRAWING FUCNTIONS---------------------------------------
    
    // Draws a pre-stylized button at a specified y-coordinate. Highlights the selected theme button.
    func drawButton(stats: Array<Int>){
        let button = SKShapeNode()
        button.path = UIBezierPath(roundedRect: CGRect(x: -200, y: stats[0], width: 400, height: stats[1]), cornerRadius: 30).cgPath
        if buttonPress == buttonPressTracker{
            button.fillColor = buttonPressColor
            button.strokeColor = buttonPressColor
            button.alpha = 0.75
        }
        else {
            button.fillColor = buttonColor
            button.strokeColor = buttonColor
            button.alpha = 0.25
        }
        addChild(button)
        buttonArray.append(button)
    }
    
    // Draws a selection of the pathway color options for each theme.
    func drawColorSamples(yCord: CGFloat, colors: Array<UIColor>){
        var count = 0
        for xCord in xCordColor{
            let color = SKShapeNode()
            color.path = UIBezierPath(roundedRect: CGRect(x: xCord, y: yCord, width: 66.67, height: 66.67), cornerRadius: 33.33).cgPath
            color.fillColor = colors[count]
            color.strokeColor = UIColor.lightGray
            color.alpha = 0.75
            count += 1
            addChild(color)
        }
    }
    
    // Resets buttonArray in preperation to redraw the buttons to adjust for new selected themes.
    func buttonReset(){
        for button in buttonArray {
            button.removeFromParent()
        }
        buttonPressTracker = 0
        for stats in buttonStatsCordArray{
            drawButton(stats: stats)
            buttonPressTracker += 1
        }
    }
    
    // ------------------------------------TOUCH-RELATED FUNCTIONS------------------------------------
    
    // Transfers the user to the menu screen after the user presses the return button. Registers the new theme after the user selects a theme option.
    func touchDown(atPoint pos : CGPoint) {
        if(pos.x > -200 && pos.x < 200 && pos.y > -550 && pos.y < -350) {
            let startScreen = StartScreen(fileNamed: "StartScreen")
            startScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(startScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        if(pos.x > -200 && pos.x < 200 && pos.y > 300 && pos.y < 400) {
            buttonPress = 0
            buttonReset()
            let colorTheme = "RAINBOW"
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(colorTheme, forKey: "Theme")
        }
        if(pos.x > -200 && pos.x < 200 && pos.y > 0 && pos.y < 100) {
            buttonPress = 1
            buttonReset()
            let colorTheme = "SPACE"
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(colorTheme, forKey: "Theme")
        }
        if(pos.x > -200 && pos.x < 200 && pos.y > -300 && pos.y < -200) {
            buttonPress = 2
            buttonReset()
            let colorTheme = "SUNSET"
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(colorTheme, forKey: "Theme")
        }
    }
    
    // Registers the point of contact where the user first touches the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}

