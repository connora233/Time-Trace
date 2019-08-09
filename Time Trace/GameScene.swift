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
        backgroundColor = UIColor.white
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        pathInitializer()
    }
    
    //Generates the original three rectangles in the first pathway.
    func pathInitializer(){
        drawRect(newPoint: currentStartPoint, height: currentHeight, angle: Int.random(in: 0...360))
        for _ in 1...5{
            let next = nextCoordinate(oldPoint: currentStartPoint)
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
    }
    
    //Returns the appropriate start coordinate based upon the previous line's data.
    func nextCoordinate(oldPoint: CGPoint) -> CGPoint{
        return CGPoint(x: currentStartPoint.x - CGFloat(currentHeight) * sin(CGFloat((CGFloat(currentAngle) * CGFloat.pi/180))), y: currentStartPoint.y + CGFloat(currentHeight) * cos((CGFloat(currentAngle) * CGFloat.pi/180)))
    }
    
    //Draws a rectangular path using SKShapeObject().
    func drawRect(newPoint: CGPoint, height: Int, angle: Int){
        currentEndPoint = currentStartPoint
        print("currentEnd")
        print(currentEndPoint)
        currentStartPoint = newPoint
        print("currentStart")
        print(currentStartPoint)
        currentHeight = height
        currentAngle = angle
        let color = changeColor()
        let shape = SKShapeNode()
        //Right here we decide where the path will eventually be moved by calling to adjustment()---needs a lot of work I just tried a few ideas but none were very functional
        shape.position = adjustment(end: currentEndPoint, start: currentStartPoint)
        print("position")
        print(shape.position)
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
}
