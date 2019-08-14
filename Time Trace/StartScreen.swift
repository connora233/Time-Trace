//
//  StartScene.swift
//  Time Trace
//
//  Created by Connor Anderson on 8/9/19.
//  Copyright © 2019 TTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScreen: SKScene {
    
    let gameScene = GameScene(fileNamed: "GameScene")

    //------------------------------------VARIABLE DECLARATION------------------------------------
    // Variable declaration for general game constants.
    private var screenWidth : CGFloat = CGFloat(UIScreen.main.bounds.width)
    private var screenHeight : CGFloat = CGFloat(UIScreen.main.bounds.height)
    
    // Variable declaration for background animation.
    private var delay : Int = 0
    
    // Variable declaration related to screen objects.
    private var touchDetection : SKShapeNode?
    private var shapeArray : Array<SKShapeNode> = []
    private var ghostArray : Array<SKShapeNode> = []
    private var circleArray : Array<SKShapeNode> = []
    
    // Variable declaration for path color changing.
    private var colorTracker : Int = 0
    private var colorArray : Array<UIColor> = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    
    // Variable declaration for the rectangle-in-use's data.
    private var currentStartPoint : CGPoint = CGPoint(x: 0, y: 0)
    private var currentAngle : Int = 0
    private var currentHeight : Int = 300
    private var currentWidth : CGFloat = 100
    private var currentRadius : CGFloat = 50
    
    // Variable declaration for pathway alignment.
    private var end : CGPoint = CGPoint(x: 0, y: 0)
    private var previousEnd: CGPoint = CGPoint(x: 0, y: 0)
    
    // Variable declaration for game mechanics.
    private var gameStarted: Bool = false
    private var gameOver: Bool = true
    private var secondTouched: Bool = false
    
    private var colorTheme : String = "RAINBOW"
    private var buttonColor : UIColor = UIColor.lightGray
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Creates a fading circle shape node to track the user's touch movements. Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        
        let startButton = SKShapeNode()
        startButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -50, width: 400, height: 200), cornerRadius: currentRadius).cgPath
        startButton.fillColor = buttonColor
        startButton.strokeColor = buttonColor
        startButton.alpha = 0.25
        addChild(startButton)
        
        let settingsButton = SKShapeNode()
        settingsButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -300, width: 400, height: 200), cornerRadius: currentRadius).cgPath
        settingsButton.fillColor = buttonColor
        settingsButton.strokeColor = buttonColor
        settingsButton.alpha = 0.25
        addChild(settingsButton)
        
        let objectiveButton = SKShapeNode()
        objectiveButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -550, width: 400, height: 200), cornerRadius: currentRadius).cgPath
        objectiveButton.fillColor = buttonColor
        objectiveButton.strokeColor = buttonColor
        objectiveButton.alpha = 0.25
        addChild(objectiveButton)
        
        startScreenInitializer()
    }
    
    // Draws initial three pathways and start-indication circle.
    func startScreenInitializer(){
        currentAngle = Int.random(in: 0...360)
        currentHeight = Int.random(in: 300...500)
        drawRect(newPoint: currentStartPoint, height: currentHeight, angle: currentAngle)
        for _ in 1...2{
            addPath()
        }
    }
    
    func adjustTheme() {
        let userDefaults = Foundation.UserDefaults.standard
        colorTheme = userDefaults.string(forKey: "Theme")!
        if colorTheme == "RAINBOW" {
            backgroundColor = UIColor.white
            colorArray = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
            buttonColor = UIColor.lightGray
        }
        if colorTheme == "COOL" {
            backgroundColor = UIColor(red: 0, green: 0.6588, blue: 0.9882, alpha: 1.0)
            colorArray = [UIColor(red: 0.0941, green: 0, blue: 0.4392, alpha: 1.0), UIColor.purple, UIColor.blue, UIColor(red: 0, green: 0.9176, blue: 0.9686, alpha: 1.0), UIColor.green, UIColor(red: 0.0471, green: 0.498, blue: 0, alpha: 1.0)]
            buttonColor = UIColor.white
        }
        if colorTheme == "WARM" {
            backgroundColor = UIColor(red: 0.9373, green: 0.6706, blue: 0, alpha: 1.0)
            colorArray = [UIColor.red, UIColor(red: 0.7765, green: 0, blue: 0.2431, alpha: 1.0), UIColor.orange, UIColor(red: 0.9686, green: 0.7412, blue: 0, alpha: 1.0), UIColor.yellow, UIColor(red: 0.9765, green: 0.898, blue: 0, alpha: 0.75)]
            buttonColor = UIColor.white
        }
    }
    
    //------------------------------------ANIMATION-RELATED FUCNTIONS------------------------------------
    
    // Runs every frame to assist in the generation of the background animation. 
    override func update(_ currentTime: TimeInterval) {
        drawLines()
    }
    
    // Generates and controls the speed at which the background animation runs.
    func drawLines() {
        if(delay % 15 == 0) {
            addPath()
            if(shapeArray.count > 3) {
                shapeArray[0].removeFromParent()
                shapeArray.remove(at: 0)
            }
        }
        delay += 1
    }
    
    //------------------------------------PATHWAY GENERATION FUCNTIONS------------------------------------
    
    // Generates additional paths based upon data from prior paths and ensures they remain on the screen.
    func addPath() {
        previousEnd = end
        end = prevCoordinateEnd(angle: currentAngle, height: currentHeight)
        currentAngle = Int.random(in: 0...360)
        currentHeight = Int.random(in: 300...500)
        var screen = false
        while(!screen){
            drawGhostRect(newPoint: nextCoordinateStart(currentAngle: currentAngle), height: currentHeight, angle: currentAngle)
            if(onScreen(point: prevCoordinateEnd(angle: currentAngle, height: currentHeight))){
                screen = true
                ghostArray[0].removeFromParent()
                ghostArray.remove(at: 0)
                break
            }
            ghostArray[0].removeFromParent()
            ghostArray.remove(at: 0)
            currentAngle = Int.random(in: 0...360)
            currentHeight = Int.random(in: 300...500)
        }
        drawRect(newPoint: nextCoordinateStart(currentAngle: currentAngle), height: currentHeight, angle: currentAngle)
    }
    
    // Determines if a point is on the screen.
    func onScreen(point: CGPoint) -> Bool {
        let bounds = currentRadius/2 + 10
        if (point.x < (-300 + bounds)) || (point.x > (300 - bounds))  {
            return false
        }
        if (point.y < (-630 + bounds)) || (point.y > (630 - bounds)) {
            return false
        }
        if(abs(previousEnd.x - point.x) < 75 || abs(previousEnd.y - point.y) < 150) {
            return false
        }
        return true
    }
    
    // Returns a coordinate that can be used by future generated rectangles to align their position to the proper location on the screen.
    func prevCoordinateEnd(angle: Int, height: Int) -> CGPoint {
        let vectorLength = (pow(currentWidth/2, 2) + pow(CGFloat(height)-currentRadius, 2)).squareRoot()
        let vectorAngle = atan((CGFloat(height)-currentRadius) / (currentWidth/2))
        let angleAddition = (CGFloat(angle) * CGFloat.pi/180)
        let adjustedAngle = vectorAngle + angleAddition
        
        let newX = vectorLength * cos(adjustedAngle)
        let newY = vectorLength * sin(adjustedAngle)
        
        return CGPoint(x: newX + currentStartPoint.x, y: newY + currentStartPoint.y)
    }
    
    // Returns a coordinate that (when used as the position of a newly generated rectangle) lines up the new pathway with the second most-recent pathway.
    func nextCoordinateStart(currentAngle: Int) -> CGPoint {
        let vectorLength = (pow(currentWidth/2, 2) + pow(CGFloat(currentRadius), 2)).squareRoot()
        let vectorAngle = atan(CGFloat(currentRadius) / (currentWidth/2))
        let angleAddition = (CGFloat(currentAngle) * CGFloat.pi/180)
        let adjustedAngle = vectorAngle + angleAddition
        
        let newX = vectorLength * cos(adjustedAngle)
        let newY = vectorLength * sin(adjustedAngle)
        
        return CGPoint(x: end.x - newX, y: end.y - newY)
    }
    
    //---------------------------------------DRAWING FUCNTIONS---------------------------------------
    
    // Draws a rectangular path using SKShapeObject().
    func drawRect(newPoint: CGPoint, height: Int, angle: Int){
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle
        
        let rectangle = SKShapeNode()
        rectangle.position = CGPoint(x: currentStartPoint.x, y: currentStartPoint.y)
        rectangle.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: currentWidth, height: CGFloat(currentHeight)), cornerRadius: currentRadius).cgPath
        
        let color = changeColor()
        rectangle.fillColor = color
        rectangle.strokeColor = color
        rectangle.alpha = 0.75
        addChild(rectangle)
        shapeArray.append(rectangle)
        
        let radians = CGFloat.pi * CGFloat(angle) / 180
        rectangle.zRotation = CGFloat(radians)
    }
    
    // Helper function used to determine if a rectangle with given characteristics will remain on the screen if drawn as the next pathway.
    func drawGhostRect(newPoint: CGPoint, height: Int, angle: Int){
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle
        
        let shape = SKShapeNode()
        shape.position = CGPoint(x: currentStartPoint.x, y: currentStartPoint.y)
        shape.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: currentWidth, height: CGFloat(currentHeight)), cornerRadius: currentRadius).cgPath
        shape.fillColor = UIColor.clear
        shape.strokeColor = UIColor.clear
        shape.alpha = 0.4
        addChild(shape)
        ghostArray.append(shape)
        let radians = CGFloat.pi * CGFloat(angle) / 180
        shape.zRotation = CGFloat(radians)
    }
    
    //------------------------------------COLOR-RELATED FUCNTION------------------------------------
    
    // Returns the next color in colorArray.
    func changeColor() -> UIColor {
        let modulus = colorTracker % 6
        colorTracker += 1
        return colorArray[modulus]
    }
    
    //------------------------------------TOUCH-RELATED FUCNTIONS------------------------------------
    
    func touchDown(atPoint pos : CGPoint) {
        if(pos.x > -200 && pos.x < 200 && pos.y > -50 && pos.y < 150) {
            gameScene!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        
        if(pos.x > -200 && pos.x < 200 && pos.y > -300 && pos.y < -100) {
            let objectiveScreen = ObjectiveScreen(fileNamed: "ObjectiveScreen")
            objectiveScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(objectiveScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        
        if(pos.x > -200 && pos.x < 200 && pos.y > -550 && pos.y < -350) {
            let settingsScreen = SettingsScreen(fileNamed: "SettingsScreen")
            settingsScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(settingsScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
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
