//
//  GameScene.swift
//  SkijumpDeluxTerje
//
//  Created by Daniel Haugstvedt on 15/02/16.
//  Copyright (c) 2016 Daniel Haugstvedt. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let Node:UInt32 = 0
    static let Jumper:UInt32 = 0b1 //1
    static let Hill:UInt32 = 0b100 //2
}

class GameScene: SKScene {
  
  
    
    //MARK: - Constants
    // Logical resolution iPad 768 x 1024
    // Physical size 7.68 m x 10.28 m
    // Each pixel is a cm
    // Chose width to be 400 m, That means 40000 pixels!
    // Logical height(keeping aspect ratio)  768/1024*40000 = 30000 = 300 m
    // Game will be 30000 x 40000
    
    // All constants that are in meters must be multiplied with 100 because a point is 0.01 m!
    // I am not sure how big a point should be (when I know it will be easier to get the zoom and the camera working)
    
    private struct InRunInMetersAndDegrees {
        static let LengthBeforeTransitionCureve:CGFloat = 120.0*100 //m
        static let LengthOfTakeOffTable:CGFloat = 10.0*100 //m
        static let TransitionCureveRadius:CGFloat = 100.0*100 //m
        static let HeightOfTakeOffTable:CGFloat = 5.0*100 //m
        static let gradientInRun:CGFloat = 32.0 //degrees
        static let gradientTable:CGFloat = 6.0 //degrees
    }
    
    private struct LandingAreaInMetersAndDegrees {
        static let gradientAtBaseOfTakeOff:CGFloat = 22.0
        static let lengthOfLanding:CGFloat = 200.0*100 //m
    }
    
    private struct JumperInMetersAndDegrees {
        static let Height:CGFloat = 2.0 * 100 //m
    }
    
    private struct GeometryConstants {
        static let StartingPoint = CGPoint(x: 20.0*100, y: 200.0*100) //m
        static let JumperStartOffset = CGPoint(x: 1.0*100, y: 1.0*100) //m
        static let ScaleOfCamera:CGFloat = 0.1
    }
    
    private struct TimingConstants {
        static let WaitBeforeStartAnimation:CFTimeInterval = 0.5
        static let StartAnimation:CFTimeInterval = 3.0
    }
  
    let myCamera = SKCameraNode()
    var dt:CFTimeInterval = 0.0
    var previousTime:CFTimeInterval = 0
    var gameHasStarted = false
    var gameHasEnded = false

    //MARK: - Lifecycle
    
    override func didMoveToView(view: SKView) {
        print(view.frame)
        print(self.frame)
        backgroundColor = SKColor.whiteColor()
        drawInRun()
        myCamera.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(self.myCamera)
        camera = self.myCamera
        startGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil && gameHasStarted {
            addBall()
        }
    }
   
    // TODO: Adding camera moves to the camera origin (that is the problem not the rendering)
    override func update(currentTime: CFTimeInterval) {
        if !gameHasStarted || gameHasEnded {
            return
        }
        if previousTime == 0 {
            previousTime = currentTime
            return
        }
        dt = currentTime - previousTime
        previousTime = currentTime
        let targetPosition = childNodeWithName("ball")?.position ?? GeometryConstants.StartingPoint
        myCamera.runAction(SKAction.moveTo(targetPosition, duration: dt))
    }
    
    //MARK: - Helper functions
    
    func startGame() {
        if let oldBall = childNodeWithName("ball") {
            oldBall.removeFromParent()
        }
        let waitAction = SKAction.waitForDuration(TimingConstants.WaitBeforeStartAnimation)
        let scaleAction = SKAction.scaleTo(GeometryConstants.ScaleOfCamera, duration: TimingConstants.StartAnimation)
        let moveAction = SKAction.moveTo(GeometryConstants.StartingPoint, duration: TimingConstants.StartAnimation)
        let startCodeAction = SKAction.runBlock({ [unowned self] in
            self.addBall()
            self.gameHasStarted = true
            })
        myCamera.runAction(SKAction.sequence([waitAction, SKAction.group([scaleAction, moveAction]), startCodeAction ]))
    }
    
    func drawInRun() {
        let topOfRunIn = GeometryConstants.StartingPoint
        let endOfTopRunIn = topOfRunIn + CGPoint(angle: -InRunInMetersAndDegrees.gradientInRun.degreesToRadians()) * InRunInMetersAndDegrees.LengthBeforeTransitionCureve
        let circleCenter = endOfTopRunIn + CGPoint(angle: CGFloat(M_PI/2) - InRunInMetersAndDegrees.gradientInRun.degreesToRadians()) * InRunInMetersAndDegrees.TransitionCureveRadius

        let bzJumpHillPath = UIBezierPath()
        bzJumpHillPath.moveToPoint(topOfRunIn)
        bzJumpHillPath.addLineToPoint(endOfTopRunIn)
        bzJumpHillPath.addArcWithCenter(circleCenter,   radius: InRunInMetersAndDegrees.TransitionCureveRadius,
                                                startAngle: -CGFloat(M_PI)/2 - InRunInMetersAndDegrees.gradientInRun.degreesToRadians(),
                                                endAngle: -CGFloat(M_PI)/2 - InRunInMetersAndDegrees.gradientTable.degreesToRadians(),
                                                clockwise: true)
        
        let endOfTransitionCurve = bzJumpHillPath.currentPoint
        let endOfTakeOffTable = endOfTransitionCurve + CGPoint(angle: -InRunInMetersAndDegrees.gradientTable.degreesToRadians()) * InRunInMetersAndDegrees.LengthOfTakeOffTable
        let topOfLandingHill = endOfTakeOffTable - CGPoint(x:0,y: InRunInMetersAndDegrees.HeightOfTakeOffTable)
        let endOfLandingHill = topOfLandingHill + CGPoint(angle: -LandingAreaInMetersAndDegrees.gradientAtBaseOfTakeOff.degreesToRadians()) * LandingAreaInMetersAndDegrees.lengthOfLanding
        
        bzJumpHillPath.addLineToPoint(endOfTakeOffTable)
        bzJumpHillPath.addLineToPoint(topOfLandingHill)
        bzJumpHillPath.addLineToPoint(endOfLandingHill)
        
        let jumpHillNode = SKShapeNode(path: bzJumpHillPath.CGPath)
        jumpHillNode.lineWidth = 100
        jumpHillNode.strokeColor = SKColor.greenColor()
        jumpHillNode.physicsBody = SKPhysicsBody(edgeChainFromPath: bzJumpHillPath.CGPath)
        jumpHillNode.physicsBody?.dynamic = false
        addChild(jumpHillNode)
    }
    
    func addBall() {
        if let oldBall = childNodeWithName("ball") {
            oldBall.removeFromParent()
        }
        let ball = SKShapeNode(circleOfRadius: JumperInMetersAndDegrees.Height/2)
        ball.position = GeometryConstants.StartingPoint + GeometryConstants.JumperStartOffset
        ball.fillColor = SKColor.redColor()
        ball.physicsBody = SKPhysicsBody(circleOfRadius: JumperInMetersAndDegrees.Height/2)
        ball.name = "ball"
        addChild(ball)
    }
    
}
