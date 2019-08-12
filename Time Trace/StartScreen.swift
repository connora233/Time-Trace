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
    
    
    override func didMove(to view: SKView) {
        print("running")
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        let startButton = SKShapeNode()
        startButton.path = UIBezierPath(roundedRect: CGRect(x: -200, y: -250, width: 400, height: 250), cornerRadius: currentRadius).cgPath
        startButton.fillColor = UIColor.green
        startButton.strokeColor = UIColor.green
        addChild(startButton)
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
