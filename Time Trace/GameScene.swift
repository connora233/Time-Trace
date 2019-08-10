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
    private var colorArray : Array<UIColor> = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    
    // Variable declaration for the rectangle-in-use's data
    private var currentCenterEnd : CGPoint = CGPoint(x: 0, y: 0)
    private var currentCenterStart : CGPoint = CGPoint(x: 0, y: 0)
    private var currentStartPoint : CGPoint = CGPoint(x: 0, y: 0)
    private var currentPosition : CGPoint = CGPoint(x: 0, y: 0)
    private var currentAngle : Int = 0
    private var currentHeight : Int = 300
    private var currentWidth : CGFloat = 60
    private var currentRadius : CGFloat = 30
    
    // Variable declaration for pathway alignment
    private var end : CGPoint = CGPoint(x: 0, y: 0)
    private var start : CGPoint = CGPoint(x: 0, y: 0)
    
    // Creates a fading circle shape node to track the user's touch movements. Draws a rectangles in a random location on the screen.
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        pathInitializer()
    }
    func pathInitializer(){
        currentAngle = Int.random(in: 0...360)
        drawRect(newPoint: currentStartPoint, height: Int.random(in: 200...400), angle: currentAngle)
        for _ in 1...5{
            addPath()
        }
    }
    
    // Generates additional paths based upon data from prior paths.
    func addPath() {
        let endPoint = nextCoordinateEnd()
        currentAngle = Int.random(in: 0...360)
        drawRect(newPoint: nextCoordinateStart(currentAngle: currentAngle), height: Int.random(in: 200...400), angle: currentAngle)
    }
    
    // Returns a coordinate that can be used by future generated rectangles to align their position to the proper location on the screen.
    func nextCoordinateEnd() -> CGPoint {
        let vectorLength = (pow(currentWidth/2, 2) + pow(CGFloat(currentHeight)-currentRadius, 2)).squareRoot()
        let vectorAngle = atan((CGFloat(currentHeight)-currentRadius) / (currentWidth/2))
        let angleAddition = (CGFloat(currentAngle) * CGFloat.pi/180)
        let adjustedAngle = vectorAngle + angleAddition
        
        let newX = vectorLength * cos(adjustedAngle)
        let newY = vectorLength * sin(adjustedAngle)
        
        end = CGPoint(x: newX + currentStartPoint.x, y: newY + currentStartPoint.y)
        
        return end
    }
    
    // Returns a coordinate that (when used as the position of a newly generated rectangle) lines up the new pathway with the second most-recent pathway.
    func nextCoordinateStart(currentAngle: Int) -> CGPoint {
        let vectorLength = (pow(currentWidth/2, 2) + pow(CGFloat(currentRadius), 2)).squareRoot()
        let vectorAngle = atan(CGFloat(currentRadius) / (currentWidth/2))
        let angleAddition = (CGFloat(currentAngle) * CGFloat.pi/180)
        let adjustedAngle = vectorAngle + angleAddition
        
        let newX = vectorLength * cos(adjustedAngle)
        let newY = vectorLength * sin(adjustedAngle)
        
        start = CGPoint(x: end.x - newX, y: end.y - newY)
       
        return start
    }
    
    //Draws a rectangular path using SKShapeObject().
    func drawRect(newPoint: CGPoint, height: Int, angle: Int){
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle
        
        let shape = SKShapeNode()
        shape.position = CGPoint(x: currentStartPoint.x, y: currentStartPoint.y)
        shape.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: currentWidth, height: CGFloat(currentHeight)), cornerRadius: currentRadius).cgPath
        
        let color = changeColor()
        shape.fillColor = color
        shape.strokeColor = color
        shape.alpha = 0.4
        addChild(shape)
        shapeArray.append(shape)
        
        let radians = CGFloat.pi * CGFloat(angle) / 180
        shape.zRotation = CGFloat(radians)
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
        for shape in shapeArray{
            if shape.contains(touch.location(in: self)) {
                print("touched")
            }
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        for shape in shapeArray{
            if shape.contains(touch.location(in: self)) {
                print("touched")
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
    
    // Temporarily moved--workability to be determined in a future edit.
    /*func inLine() {
        drawRect(newPoint: currentStartPoint, height: currentHeight, angle: Int.random(in: 0...360))
        for _ in 1...5{
            let xB = CGFloat(1)
            let yB = CGFloat(350)
            let low = 200
            let high = 225
            if next.x >= 0 && next.y >= 0 && next.y <= yB && next.x <= xB{
                print("q1 c, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 0...180))
            }
            else if next.x >= 0 && next.y >= 0 && next.y <= yB && next.x > xB{
                print("q1 c, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 70...110))
            }
            else if next.x >= 0 && next.y >= 0 && next.y > yB && next.x <= xB{
                print("q1 o, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 90...180))
            }
            else if next.x >= 0 && next.y >= 0 && next.y > yB && next.x > xB{
                print("q1 o, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 120...130))
            }
            else if next.x < 0 && next.y >= 0 && next.y <= yB && next.x <= xB{
                print("q2 c, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 180...360))
            }
            else if next.x < 0 && next.y >= 0 && next.y <= yB && next.x > xB{
                print("q2 c, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 260...280))
            }
            else if next.x < 0 && next.y >= 0 && next.y > yB && next.x <= xB{
                print("q2 o, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 180...270))
            }
            else if next.x < 0 && next.y >= 0 && next.y > yB && next.x > xB{
                print("q2 o, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 220...230))
            }
            else if next.x < 0 && next.y < 0 && next.y > -yB && next.x >= -xB{
                print("q3 c, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 180...360))
            }
            else if next.x < 0 && next.y < 0 && next.y > -yB && next.x < -xB{
                print("q3 c, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 260...280))
            }
            else if next.x < 0 && next.y < 0 && next.y <= -yB && next.x >= -xB{
                print("q3 o, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 270...360))
            }
            else if next.x < 0 && next.y < 0 && next.y <= -yB && next.x < -xB{
                print("q3 o, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 310...320))
            }
            else if next.x >= 0 && next.y < 0 && next.y > -yB && next.x >= -xB{
                print("q4 c, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 0...180))
            }
            else if next.x >= 0 && next.y < 0 && next.y > -yB && next.x < -xB{
                print("q4 c, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 80...100))
            }
            else if next.x >= 0 && next.y < 0 && next.y <= -yB && next.x >= -xB{
                print("q4 o, c")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 0...90))
            }
            else if next.x >= 0 && next.y < 0 && next.y <= -yB && next.x < -xB{
                print("q4 o, o")
                drawRect(newPoint: next, height: Int.random(in: low...high), angle: Int.random(in: 40...50))
            }
        }
    }*/
}
