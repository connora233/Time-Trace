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
    
    // Variable declaration for general constants
    private var touchDetection : SKShapeNode?
    private var shapeArray : Array<SKShapeNode> = []
    private var screenWidth : Int = Int(UIScreen.main.bounds.width)
    private var screenHeight : Int = Int(UIScreen.main.bounds.height)
    let gameScene = GameScene(fileNamed: "GameScene")
    
    // Variable declaration for path color changing
    private var colorTracker : Int = 0
    private var colorArray : Array<UIColor> = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    
    // Variable declaration for the rectangle-in-use's data
    private var currentEndPoint : CGPoint = CGPoint(x: 0, y: 0)
    private var currentStartPoint : CGPoint = CGPoint(x: 0, y: 0)
    private var currentPosition : CGPoint = CGPoint(x: 0, y: 0)
    private var currentAngle : Int = 45
    private var currentHeight : Int = 200
    private var currentWidth : CGFloat = 60
    private var currentRadius : CGFloat = 30
    private var test : Int = 0
    
    // Creates a fading circle shape node to track the user's touch movements. Draws a rectangles in a random location on the screen.
    override func didMove(to view: SKView) {
        print("running")
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        let button = SKShapeNode()
        button.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -250, width: 400, height: 250), cornerRadius: currentRadius).cgPath
        button.fillColor = UIColor.red
        button.strokeColor = UIColor.red
        addChild(button)
    }
    
    //Returns the appropriate start coordinate based upon the previous line's data.
    func nextCoordinate(oldPoint: CGPoint) -> CGPoint{
        return CGPoint(x: currentStartPoint.x - CGFloat(currentHeight) * sin(CGFloat((CGFloat(currentAngle) * CGFloat.pi/180))), y: currentStartPoint.y + CGFloat(currentHeight) * cos((CGFloat(currentAngle) * CGFloat.pi/180)))
    }
    
    //Draws a rectangular path using SKShapeObject().
    func drawRect(newPoint: CGPoint, height: Int, angle: Int){
        currentEndPoint = currentStartPoint
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle
        let color = changeColor()
        let shape = SKShapeNode()
        //Right here we decide where the path will eventually be moved by calling to adjustment()---needs a lot of work I just tried a few ideas but none were very functional
        shape.position = adjustment(end: currentEndPoint, start: currentStartPoint)
        //Draws the path at 0,0, but the position we already established will "translate it" to the desired position
        shape.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: currentWidth, height: CGFloat(currentHeight)), cornerRadius: currentRadius).cgPath
        shape.fillColor = color
        shape.strokeColor = color
        shape.alpha = 0.4
        addChild(shape)
        shapeArray.append(shape)
        
        //I tried line 83 as a way of bettering adjustment()--might be more harm than good, not vital to drawRect()
        currentStartPoint = shape.position
        
        //NOTE!!!! All angles are in radians everywhere, but this function takes in degrees. If you try to rotate elsewhere, make sure you're converting
        let radians = CGFloat.pi * CGFloat(angle) / 180
        shape.zRotation = CGFloat(radians)
    }
    
    //NEEDS OPTIMIZING!!! Attempts to move the rotated path to the correct position.
    func adjustment(end: CGPoint, start: CGPoint) -> CGPoint{
        var xCord = CGFloat(0.0)
        var yCord = CGFloat(0.0)
        if currentEndPoint.x < currentStartPoint.x {
            xCord = currentStartPoint.x + currentWidth/2
        }
        else if currentEndPoint.x == currentStartPoint.x {
            xCord = currentStartPoint.x
        }
        else{
            xCord = currentStartPoint.x - currentWidth/2
        }
        
        if currentEndPoint.y < currentStartPoint.y {
            yCord = currentStartPoint.y - currentWidth/2
        }
        else if currentEndPoint.y == currentStartPoint.y {
            yCord = currentStartPoint.y
        }
        else{
            yCord = currentStartPoint.y + currentWidth/2
        }
        return CGPoint(x: xCord, y: yCord)
        
    }
    
    // Returns the next color in colorArray.
    func changeColor() -> UIColor {
        let modulus = colorTracker % 6
        colorTracker += 1
        return colorArray[modulus]
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if(pos.x > -200 && pos.x < 200 && pos.y > -250 && pos.y < 0) {
            gameScene!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene!, transition: SKTransition.flipHorizontal(withDuration: 1.0))
        }
        if let n = self.touchDetection?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            n.fillColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.touchDetection?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            n.fillColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.touchDetection?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            n.fillColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        for shape in shapeArray{
            if shape.contains(touch.location(in: self)) {
            }
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        for shape in shapeArray{
            if shape.contains(touch.location(in: self)) {
            }
        }
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
