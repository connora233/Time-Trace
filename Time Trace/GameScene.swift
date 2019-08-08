//
//  GameScene.swift
//  Time Trace
//
//  Created by Connor Anderson & Ashley Granitto on 8/2/19.
//  Copyright © 2019 TTI. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Variable declaration for general constants
    private var touchDetection : SKShapeNode?
    private var shapeArray : Array<SKShapeNode> = []
    private var screenWidth : Int = Int(UIScreen.main.bounds.width)
    private var screenHeight : Int = Int(UIScreen.main.bounds.height)
    
    // Variable declaration for path color changing
    private var colorTracker : Int = 0
    private var colorArray : Array<UIColor> = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple]
    
    // Variable declaration for the rectangle-in-use's data
    private var currentStartPoint : CGPoint = CGPoint(x: 0, y: 0)
    private var currentEndPoint : CGPoint = CGPoint(x: 0, y: 0)
    private var currentPosition : CGPoint = CGPoint(x: 0, y: 0)
    private var currentAngle : Int = 45
    private var currentHeight : Int = 200
    private var currentWidth : CGFloat = 60
    private var currentRadius : CGFloat = 30
    private var test : Int = 0
    
    // Creates a fading circle shape node to track the user's touch movements. Draws a rectangles in a random location on the screen.
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        pathInitializer()
    }
    
    //Generates the original three rectangles in the first pathway.
    func pathInitializer(){
        drawRect(newPoint: currentStartPoint, height: currentHeight, angle: currentAngle)
        drawRect(newPoint: nextCoordinate(oldPoint: currentStartPoint), height: currentHeight, angle: 0)
        drawRect(newPoint: nextCoordinate(oldPoint: currentStartPoint), height: currentHeight, angle: 0)
        //drawRect(newPoint: nextCoordinate(oldPoint: currentStartPoint), height: Int.random(in: 300...400), angle: Int.random(in: 0...360))

    }
    
    //Returns the appropriate start coordinate based upon the previous line's data.
    func nextCoordinate(oldPoint: CGPoint) -> CGPoint{
        return CGPoint(x: currentStartPoint.x - CGFloat(currentHeight) * sin(CGFloat((CGFloat(currentAngle) * CGFloat.pi/180))), y: currentStartPoint.y + CGFloat(currentHeight) * cos((CGFloat(currentAngle) * CGFloat.pi/180)))
    }
    
    //Draws a rectangular path using SKShapeObject().
    func drawRect(newPoint: CGPoint, height: Int, angle: Int){
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle
        let color = changeColor()
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: currentStartPoint.x, y: currentStartPoint.y, width: currentWidth, height: CGFloat(currentHeight)), cornerRadius: currentRadius).cgPath
        shape.fillColor = color
        shape.strokeColor = color
        shape.alpha = 0.25
        addChild(shape)
        shapeArray.append(shape)
        if test < 1{
            let radians = CGFloat.pi * CGFloat(angle) / 180
            shape.zRotation = CGFloat(radians)
            test += 1
        }
    }
    
    // Returns the next color in colorArray.
    func changeColor() -> UIColor {
        let modulus = colorTracker % 6
        colorTracker += 1
        return colorArray[modulus]
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.touchDetection?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            n.fillColor = SKColor.green
            self.addChild(n)
            
            print(pos)
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
        if shapeArray[0].contains(touch.location(in: self)) {
            print("touched")
        }
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
