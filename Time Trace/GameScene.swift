//
//  GameScene.swift
//  Time Trace
//
//  Created by Connor Anderson & Ashley Granitto on 8/2/19.
//  Copyright © 2019 TTI. All rights reserved.


import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //------------------------------------VARIABLE DECLARATION------------------------------------
    
    // Variable declaration for general game constants.
    private var screenWidth : CGFloat = CGFloat(UIScreen.main.bounds.width)
    private var screenHeight : CGFloat = CGFloat(UIScreen.main.bounds.height)
    private var score : Int = 0
    private var hScore : Int = 0
    private var tempScore : String? = ""
    
    // Variable declaration related to screen objects.
    private var touchDetection : SKShapeNode?
    private var scoreLabel : SKLabelNode?
    private var rectangleArray : Array<SKShapeNode> = []
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
    private var clockTrue : Bool = false
    private var count : Int = 0
    private var fadeTimeSec : Double = 1.0
    
    // Variable declaration for theme implementation.
    private var tempTheme : String? = ""
    private var colorTheme : String = "RAINBOW"
    private var circleColor : UIColor = UIColor.white
    
    // Variable declaration for changing to GameOverScreen.
    let gameOverScreen = GameOverScreen(fileNamed: "GameOverScreen")
    
    //------------------------------------INITIALIZATION FUCNTIONS------------------------------------
    
    // Creates a fading circle shape node to track the user's touch movements. Initializes the game set up.
    override func didMove(to view: SKView) {
        adjustTheme()
        self.touchDetection = SKShapeNode.init(circleOfRadius: (self.size.width + self.size.height) * 0.02)
        if let circleIndicator = self.touchDetection {
            circleIndicator.zPosition = 1
            circleIndicator.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25),                                                         SKAction.removeFromParent()]))
        }
        scoreLabelInitializer()
        gameInitializer()
    }
    
    // Draws initial three pathways and start-indication circle.
    func gameInitializer(){
        currentAngle = Int.random(in: 0...360)
        currentHeight = Int.random(in: 200...300)
        drawRect(newPoint: currentStartPoint, height: currentHeight, angle: currentAngle)
        drawCircle(center: circleCoordinate())
        for _ in 1...2{
            addPath()
        }
    }
    
    // Initializes the score label.
    func scoreLabelInitializer(){
        scoreLabel = SKLabelNode(fontNamed: "Futura Medium")
        scoreLabel?.text = "0"
        scoreLabel?.fontSize = 98
        scoreLabel?.fontColor = UIColor.black
        scoreLabel?.position = CGPoint(x: 0, y: screenHeight * 0.5)
        scoreLabel?.zPosition = 1
        self.addChild(scoreLabel!)
    }
    
    // Adjusts the background, circle color, and pathway colors based upon the theme selected in the settings.
    func adjustTheme() {
        let userDefaults = Foundation.UserDefaults.standard
        tempTheme = userDefaults.string(forKey: "Theme")
        if(tempTheme == nil) {
            colorTheme = "RAINBOW"
            backgroundColor = UIColor(red: 0.6667, green: 0.9529, blue: 1, alpha: 1.0)
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
            colorArray = [UIColor(red: 0, green: 0.5804, blue: 0.698, alpha: 1.0), UIColor(red: 0, green: 0.7176, blue: 0.8784, alpha: 1.0), UIColor(red: 0.9686, green: 0.3647, blue: 0.3098, alpha: 1.0), UIColor.white, UIColor(red: 1, green: 0.5451, blue: 0.1961, alpha: 1.0), UIColor(red: 1, green: 0.9176, blue: 0.3176, alpha: 1.0)]
        }
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
            currentHeight = Int.random(in: 375...500)
        }
    }
    
    //------------------------------------TIME OUT FUCNTIONS------------------------------------
    
    // Removes rectangles from the array of touchable path objects after they have disolved from the game screen.
    override func update(_ currentTime: TimeInterval) {
        let fadeTimeMin = fadeTimeSec * 60 + 1
        if gameStarted && clockTrue{
            if count != 0 && count % Int(fadeTimeMin) == 0 {
                rectangleArray.remove(at: 0)
                gameOver = true
                clockTrue = false
            }
            count += 1
        }
    }
    
    // Checks to see if the user's high score has changed.
    func checkHighScore() {
        let userDefaults = Foundation.UserDefaults.standard
        let highScore = userDefaults.string(forKey: "HighScore")
        tempScore = highScore
        if(tempScore == nil) {
            hScore = -1
        }
        else {
            hScore = Int(tempScore!)!
        }
        if(hScore == -1 || score > hScore) {
            userDefaults.set(score, forKey: "HighScore")
        }
    }
    
    // Caches the user's score.
    func ended() {
        let currScore = String(score)
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(currScore, forKey: "Score")
    }
    
    //------------------------------------CIRCLE GENERATION FUCNTION------------------------------------
    
    // Returns a coordinate that (when used as the position of a newly generated rectangle) lines up the new pathway with the second most-recent pathway.
    func circleCoordinate() -> CGPoint {
        let vectorLength = (pow(currentWidth/2, 2) + pow(CGFloat(currentRadius), 2)).squareRoot()
        let vectorAngle = atan(CGFloat(currentRadius) / (currentWidth/2))
        let angleAddition = (CGFloat(currentAngle) * CGFloat.pi/180)
        let adjustedAngle = vectorAngle + angleAddition
        
        let newX = vectorLength * cos(adjustedAngle)
        let newY = vectorLength * sin(adjustedAngle)
        
        return CGPoint(x: newX, y: newY)
    }
    
    //---------------------------------------DRAWING FUCNTIONS---------------------------------------
    
    // Draws a circle using SKShapeObject().
    func drawCircle(center: CGPoint){
        let circle = SKShapeNode(circleOfRadius: currentRadius + 25)
        circle.position = CGPoint(x: center.x, y: center.y)
        circle.zPosition = 1
        circle.fillColor = circleColor
        circle.strokeColor = circleColor
        circle.alpha = 0.25
        self.addChild(circle)
        circleArray.append(circle)
    }
    
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
        rectangleArray.append(rectangle)
        
        let radians = CGFloat.pi * CGFloat(angle) / 180
        rectangle.zRotation = CGFloat(radians)
    }
    
    // Helper function used to determine if a rectangle with given characteristics will remain on the screen if drawn as the next pathway.
    func drawGhostRect(newPoint: CGPoint, height: Int, angle: Int){
        currentStartPoint = newPoint
        currentHeight = height
        currentAngle = angle

        let ghostRec = SKShapeNode()
        ghostRec.position = CGPoint(x: currentStartPoint.x, y: currentStartPoint.y)
        ghostRec.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: currentWidth, height: CGFloat(currentHeight)), cornerRadius: currentRadius).cgPath
        
        ghostRec.fillColor = UIColor.clear
        ghostRec.strokeColor = UIColor.clear
        ghostRec.alpha = 0.5
        addChild(ghostRec)
        ghostArray.append(ghostRec)
        
        let radians = CGFloat.pi * CGFloat(angle) / 180
        ghostRec.zRotation = CGFloat(radians)
    }
    
    //------------------------------------COLOR-RELATED FUCNTION------------------------------------
    
    // Returns the next color in colorArray.
    func changeColor() -> UIColor {
        let modulus = colorTracker % 6
        colorTracker += 1
        return colorArray[modulus]
    }
    
    //------------------------------------TOUCH-RELATED FUCNTIONS------------------------------------
    
    // Generates a circle to assist the user in location awareness after the user presses down on the screen.
    func touchDown(atPoint pos : CGPoint) {
        if let touchDownCircle = self.touchDetection?.copy() as! SKShapeNode? {
            touchDownCircle.position = pos
            touchDownCircle.strokeColor = circleColor
            touchDownCircle.fillColor = circleColor
            touchDownCircle.alpha = 0.25
            self.addChild(touchDownCircle)
        }
    }
    
    // Generates a circle to assist the user in location awareness when the user drags their finger along the screen after pressing down on the screen.
    func touchMoved(toPoint pos : CGPoint) {
        if let touchMovedCircle = self.touchDetection?.copy() as! SKShapeNode? {
            touchMovedCircle.position = pos
            touchMovedCircle.strokeColor = circleColor
            touchMovedCircle.fillColor = circleColor
            touchMovedCircle.alpha = 0.25
            self.addChild(touchMovedCircle)
        }
    }
    
    // Generates a circle to assist the user in location awareness when the user lifts their finger from the screen after previously tapping or dragging along the screen.
    func touchUp(atPoint pos : CGPoint) {
        if let touchUpCircle = self.touchDetection?.copy() as! SKShapeNode? {
            touchUpCircle.position = pos
            touchUpCircle.strokeColor = circleColor
            touchUpCircle.fillColor = circleColor
            touchUpCircle.alpha = 0.25
            self.addChild(touchUpCircle)
        }
    }
    
    // Starts the game once the user touches the first rectangle in the pathway.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if !gameStarted && rectangleArray[0].contains(touch.location(in: self)) {
            circleArray[0].removeFromParent()
            gameOver = false
            gameStarted = true
            clockTrue = true
            rectangleArray[0].run(SKAction.sequence([SKAction.fadeOut(withDuration: fadeTimeSec),                                                         SKAction.removeFromParent()]))
        }
        if !gameOver && rectangleArray[1].contains(touch.location(in: self)) {
            secondTouched = true
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    // Ensures the user keeps up with tracing the proper pathway, adding points to the user's score and ending the game when appropriate.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if !gameOver && rectangleArray[1].contains(touch.location(in: self)) {
            rectangleArray[0].removeFromParent()
            rectangleArray.remove(at: 0)
            count = 0
            clockTrue = true
            rectangleArray[0].run(SKAction.sequence([SKAction.fadeOut(withDuration: fadeTimeSec),                                                         SKAction.removeFromParent()]))
            if fadeTimeSec > 0.6 {
                fadeTimeSec *= 0.99
            }
            score += 1
            scoreLabel?.text = String(score)
            addPath()
        }
        var count = 0
        if rectangleArray[0].contains(touch.location(in: self)) {
            count += 1
        }
        if rectangleArray[1].contains(touch.location(in: self)) {
            count += 1
        }
        if gameStarted && count == 0 {
            gameOver = true
            ended()
            checkHighScore()
            gameOverScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameOverScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    // Ends the game if the user lifts their finger from the screen after the game has started.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted{
            gameOver = true
            ended()
            checkHighScore()
            gameOverScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameOverScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
            
        }
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // Registers the point the user's finger is at when the game is interrupted and ends the game automatically.
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(gameOver == false) {
            gameOver = true
            ended()
            checkHighScore()
            gameOverScreen!.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameOverScreen!, transition: SKTransition.fade(with: UIColor.white, duration: 0.75))
        }
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
