//
//  GameScene.swift
//  SkijumpDeluxTerje
//
//  Created by Daniel Haugstvedt on 15/02/16.
//  Copyright (c) 2016 Daniel Haugstvedt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    //MARK: - Constants
    // Logical resolution iPad 768 x 1024
    // Physical size 7.68 m x 10.28 m
    // Each pixel is a cm
    // Chose width to be 400 m, Let each pixel be 0.1 m
    // Logical width: width = 4000 = 400 m
    // Logical height(keeping aspect ratio)  768/1024*4000 = 3000 = 300 m
    
    // All constants that are in meters must be multiplied with 10 because a point is 0.1 m!
    // I am not sure how big a point should be (when I know it will be easier to get the zoom and the camera working)
    
    private struct InRunInMetersAndDegrees {
        static let LengthBeforeTransitionCureve:CGFloat = 120.0*10 //m
        static let LengthOfTakeOffTable:CGFloat = 10.0*10 //m
        static let TransitionCureveRadius:CGFloat = 100.0*10 //m
        static let HeightOfTakeOffTable:CGFloat = 5.0*10 //m
        static let gradientInRun:CGFloat = 32.0 //degrees
        static let gradientTable:CGFloat = 6.0 //degrees
    }
    
    private struct LandingAreaInMetersAndDegrees {
        static let gradientAtBaseOfTakeOff:CGFloat = 22.0
        static let lengthOfLanding:CGFloat = 200.0*10
    }
    
    private struct JumperInMetersAndDegrees {
        static let Height:CGFloat = 2.0 * 10//m
    }
    
    private struct GeometryConstants {
        static let StartingPoint = CGPoint(x: 20.0*10, y: 200.0*10)
        static let JumperStartOffset = CGPoint(x: 1.0*10, y: 1.0*10)
        static let ScaleOfCamera:CGFloat = 0.1
    }
    
    private struct TimingConstants {
        static let StartAnimation:CFTimeInterval = 3.0
    }
    
    let myCamera = SKCameraNode()
    var dt:CFTimeInterval = 0.0
    var previousTime:CFTimeInterval = 0
    var gameHasStarted = false
    var gameHasEnded = false

    //MARK: - Lifecycle
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        drawInRun()
        addChild(myCamera)
        camera = myCamera
        startGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil && gameHasStarted {
            addBall()
        }
    }
   
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
        let scaleAction = SKAction.scaleTo(GeometryConstants.ScaleOfCamera, duration: TimingConstants.StartAnimation)
        let moveAction = SKAction.moveTo(GeometryConstants.StartingPoint, duration: TimingConstants.StartAnimation)
        let startCodeAction = SKAction.runBlock({ [unowned self] in
            self.addBall()
            self.gameHasStarted = true
            })
        myCamera.runAction(SKAction.sequence([ SKAction.group([scaleAction, moveAction]), startCodeAction ]))
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
        jumpHillNode.lineWidth = 10
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
