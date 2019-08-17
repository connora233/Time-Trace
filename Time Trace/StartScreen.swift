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
    
    // Variable declaration for theme implementation.
    private var tempTheme : String? = ""
    private var colorTheme : String = "RAINBOW"
    private var buttonColor : UIColor = UIColor.white
    
    // Variable declaration for screen initialization.
    private var yCordArray : Array<CGFloat> = [-50, -300, -550]
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        for yCord in yCordArray {
            drawButton(yCord: yCord)
        }
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
    
    // Adjusts the background, button colors, and pathway colors based upon the theme selected in the settings.
    func adjustTheme() {
        let userDefaults = Foundation.UserDefaults.standard
        tempTheme = userDefaults.string(forKey: "Theme")
        if(tempTheme == nil) {
            colorTheme = "RAINBOW"
        }
        else {
            colorTheme = tempTheme!
        }
        if colorTheme == "RAINBOW" {
            backgroundColor = UIColor(red: 0.6667, green: 0.9529, blue: 1, alpha: 1.0)
            colorArray = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
        }
        if colorTheme == "SPACE" {
            let background = SKSpriteNode(imageNamed: "space")
            background.position = CGPoint(x: 0, y: 0)
            background.zPosition = 0
            background.scale(to: CGSize(width: screenWidth * 2, height: screenHeight * 2))
            addChild(background)
            colorArray = [UIColor(red: 0, green: 0.3961, blue: 0.6, alpha: 1.0), UIColor(red: 0, green: 0.4549, blue: 0.4784, alpha: 1.0), UIColor.white, UIColor(red: 0.8235, green: 0.7176, blue: 0.9686, alpha: 1.0), UIColor(red: 0.6, green: 0.3176, blue: 0.9686, alpha: 1.0), UIColor(red: 0.4235, green: 0.0078, blue: 0.9686, alpha: 1.0)]
        }
        if colorTheme == "SUNSET" {
            let background = SKSpriteNode(imageNamed: "sunset")
            background.position = CGPoint(x: 0, y: 0)
            background.zPosition = 0
            background.scale(to: CGSize(width: screenWidth * 2, height: screenHeight * 2))
            addChild(background)
            colorArray = [UIColor(red: 0, green: 0.5804, blue: 0.698, alpha: 1.0), UIColor(red: 0, green: 0.7176, blue: 0.8784, alpha: 1.0), UIColor(red: 0.9294, green: 0.451, blue: 0.4157, alpha: 1.0), UIColor(red: 0.9373, green: 0.702, blue: 0.1098, alpha: 1.0), UIColor(red: 0.9373, green: 0.8588, blue: 0.3451, alpha: 1.0), UIColor(red: 0.9765, green: 0.9412, blue: 0.4392, alpha: 1.0)]
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
        findAcceptableRectangle()
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
    
    // Utilizes the concept of "ghost rectangles" to test randomized rectangle characteristics until a rectangle is found that will stay on the screen when connected to the end of the previously drawn pathway.
    func findAcceptableRectangle() {
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
    }
    
    //---------------------------------------DRAWING FUCNTIONS---------------------------------------
    
    // Draws a rectangular path using SKShapeObject().
    func drawRect(newPoint: CGPoint, height: Int, angle: Int){
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle
        
        let rectangle = SKShapeNode()
        rectangle.position = CGPoint(x: currentStartPoint.x, y: currentStartPoint.y)
        rectangle.zPosition = 1
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
    
    //------------------------------------COLOR-RELATED FUCNTION------------------------------------
    
    // Returns the next color in colorArray.
    func changeColor() -> UIColor {
        let modulus = colorTracker % 6
        colorTracker += 1
        return colorArray[modulus]
    }
    
    //------------------------------------TOUCH-RELATED FUCNTIONS------------------------------------
    
    // Transfers the user to the proper screen after the user presses a button.
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
    
    // Registers the point of contact where the user first touches the screen. 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
}
