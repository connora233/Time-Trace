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
    private var currentEndPoint : CGPoint = CGPoint(x : 0, y : 0)
    private var screenWidth : Int = Int(UIScreen.main.bounds.width)
    private var screenHeight : Int = Int(UIScreen.main.bounds.height)
    
    // Creates a fading circle shape node to track the user's touch movements. Draws a rectangles in a random location on the screen.
    override func didMove(to view: SKView) {
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.01)
        if let circleIndicator = self.touchDetection {
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        pathInitializer()
    }
    
    //Generates the original three lines in the first pathway.
    func pathInitializer(){
        for _ in 1...3 {
        drawLine(points: generateNewLine())
        }
    }
    
    //Draws a line using SKShapeNode().
    func drawLine(points: Array<CGPoint>){
        currentEndPoint = points[1]
        let path = CGMutablePath()
        path.move(to:points[0])
        for point in points {
            path.addLine(to: point)
        }
        let trace = SKShapeNode()
        trace.path = path
        trace.lineWidth = 40
        trace.lineCap = .round
        trace.strokeColor = .red
        self.addChild(trace)
    }
    
    //Generates the coordinates for additional lines using the last existing line's endpoint.
    func generateNewLine() -> Array<CGPoint> {
        return [currentEndPoint, CGPoint(x: Int.random(in: -screenWidth / 2 + 15...screenWidth / 2 - 15), y: Int.random(in: -screenHeight / 2 + 20...screenHeight / 2 - 20))]
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.touchDetection?.copy() as! SKShapeNode? {
            let returnPoint = pos
            n.position = pos
            n.strokeColor = SKColor.green
            n.fillColor = SKColor.green
            self.addChild(n)
            
            print(returnPoint)
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
