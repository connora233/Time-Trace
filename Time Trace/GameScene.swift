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
    
    // Variable declaration
    private var touchDetection : SKShapeNode?
    private var currentX : Int = 0
    private var currentY : Int = 0
    private var currentHeight : Int = 0
    private var currentRotation : CGFloat = 0.0
    
    // Creates a fading circle shape node to track the user's touch movements. Draws a rectangles in a random location on the screen.
    override func didMove(to view: SKView) {
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        pathInitializer()
    }
    
    //Function that is called every frame.
    override func update(_ currentTime: TimeInterval){
        
    }
    
    //Generates the original three rectangles in the first pathway.
    func pathInitializer(){
        let degrees = 30.0
        let radian = CGFloat(degrees * Double.pi / 180)
        print(radian)
        drawRect(xCord: Int.random(in: Int(frame.width)/4...Int(frame.width)/2), yCord: Int.random(in:  Int(frame.height)/4...Int(frame.height)/2), height: Int.random(in: 100...300), radians : radian)
        //drawRect(xCord: currentX, yCord: currentY + currentHeight, height: Int.random(in: 0...300))
        //drawRect(xCord: currentX, yCord: currentY + currentHeight, height: Int.random(in: 0...300))
    }
    
    //drawRect function that uses CAShapeLayer()
    func drawRect(xCord : Int, yCord : Int, height : Int, radians : CGFloat){
        //Updates global variables with randomized data from parameters.
        currentRotation = radians
        currentX = xCord
        currentY = yCord
        currentHeight = height
        
        //For testing.
        print(currentX)
        print(currentY)
        
        //Draws a red CAShapeLayer rectangle and rotates it about the z-axis.
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: xCord, y: yCord, width: 50, height: height), cornerRadius: 25).cgPath
        layer.fillColor = UIColor.red.cgColor
        view?.layer.addSublayer(layer)
        layer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        
        //Draws a slightly smaller blue rectangle as a means of testing the rotation axis.
        let layer1 = CAShapeLayer()
        layer1.path = UIBezierPath(roundedRect: CGRect(x: xCord, y: yCord, width: 20, height: 10), cornerRadius: 25).cgPath
        layer1.fillColor = UIColor.blue.cgColor
        view?.layer.addSublayer(layer1)
        layer1.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
    }
    
    //drawRect function that uses SKShapeNode()
    func drawRect1(){
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 100), cornerRadius: 0).cgPath
        shape.fillColor = UIColor.white
        shape.strokeColor = UIColor.white
        addChild(shape)
    }
    
    func touchDown(atPoint pos : CGPoint) {
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
