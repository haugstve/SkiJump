//
//  Jumper.swift
//  SkijumpDeluxTerje
//
//  Created by Daniel Haugstvedt on 19/02/16.
//  Copyright © 2016 Daniel Haugstvedt. All rights reserved.
//

import SpriteKit

class Jumper: SKSpriteNode, CustomNodeEvents {
  
    var upperArm: SKSpriteNode!
    var lowerArm: SKSpriteNode!
    var hand: SKSpriteNode!
    
    var upperLeg: SKSpriteNode!
    var lowerLeg: SKSpriteNode!
    var foot: SKSpriteNode!
    
    var head: SKSpriteNode!

    var ski: SKSpriteNode!
  
  private struct SkiGeometry {
    static let Length:CGFloat = 200.0
    static let Tickness:CGFloat = 3.0
    static let TipRadius:CGFloat = 10.0
    static let TipDegrees:CGFloat = 45.0
  }
  
  func didMoveToScene() {
    //body = childNodeWithName("body") as! SKSpriteNode will crash, this node is the body
    
    zRotation = CGFloat(-80).degreesToRadians()
    
    upperArm = childNodeWithName("upper_arm") as! SKSpriteNode
    lowerArm = childNodeWithName("//lower_arm") as! SKSpriteNode
    hand = childNodeWithName("//hand") as! SKSpriteNode
    
    upperLeg = childNodeWithName("upper_leg") as! SKSpriteNode
    lowerLeg = childNodeWithName("//lower_leg") as! SKSpriteNode
    foot = childNodeWithName("//foot") as! SKSpriteNode
    
    head = childNodeWithName("head") as! SKSpriteNode
    
    ski = makeSki()
    foot.addChild(ski)
    
    let circle = SKSpriteNode(imageNamed: "circle")
    circle.name = "shape"
    circle.position = CGPoint(x: 50, y:50)
    circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width/2)
    foot.addChild(circle)
    

    let shoulder = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: upperArm.physicsBody!, anchor: anchorFromNode(upperArm))
    let elbow = SKPhysicsJointPin.jointWithBodyA(upperArm.physicsBody!, bodyB: lowerArm.physicsBody!, anchor: anchorFromNode(lowerArm))
    let wrist = SKPhysicsJointPin.jointWithBodyA(lowerArm.physicsBody!, bodyB: hand.physicsBody!, anchor: anchorFromNode(hand))
    
    let hipp = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: upperLeg.physicsBody!, anchor: anchorFromNode(upperLeg))
    let knee = SKPhysicsJointPin.jointWithBodyA(upperLeg.physicsBody!, bodyB: lowerLeg.physicsBody!, anchor: anchorFromNode(lowerLeg))
    let ancle = SKPhysicsJointPin.jointWithBodyA(lowerLeg.physicsBody!, bodyB: foot.physicsBody!, anchor: anchorFromNode(foot))
    
    let neck = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: head.physicsBody!, anchor: scene!.convertPoint(head.position, fromNode: self))
    
    //let binding = SKPhysicsJointPin.jointWithBodyA(foot.physicsBody!, bodyB: ski.physicsBody!, anchor: scene!.convertPoint(ski.position, fromNode: foot))
    
    lockJoint(shoulder,min: -15,max: -10)
    lockJoint(elbow,min: 0,max: 5)
    lockJoint(wrist,min: -5.0,max: 5.0)
    
    lockJoint(hipp,min: 140,max: 170)
    lockJoint(knee,min: -110,max:-90 )
    lockJoint(ancle,min: 110,max: 140)
    
    lockJoint(neck,min: -5.0, max: 5.0)
    
    
    scene?.physicsWorld.addJoint(shoulder)
    scene?.physicsWorld.addJoint(elbow)
    scene?.physicsWorld.addJoint(wrist)
    
    scene?.physicsWorld.addJoint(hipp)
    scene?.physicsWorld.addJoint(knee)
    scene?.physicsWorld.addJoint(ancle)
    
    scene?.physicsWorld.addJoint(neck)
    
    //scene?.physicsWorld.addJoint(binding)
    
  }
  
  func lockJoint(joint: SKPhysicsJointPin, min: CGFloat, max: CGFloat) {
    joint.shouldEnableLimits = true
    joint.upperAngleLimit = CGFloat(max).degreesToRadians()
    joint.lowerAngleLimit = CGFloat(min).degreesToRadians()
  }
    
    func anchorFromNode(sprite: SKNode) -> CGPoint{
        guard let scenOfSprite = sprite.scene else {
            return CGPointZero
        }
        guard let parentNode = sprite.parent else {
            return CGPointZero
        }
        let positionOfNode = sprite.position
        let positionOfTopOfNode = positionOfNode + CGPoint(x: 0, y: sprite.frame.height/2)
        let postitonOfAnchor = positionOfTopOfNode + CGPoint(x: 0, y: -sprite.frame.width/2)
        
        return scenOfSprite.convertPoint(postitonOfAnchor, fromNode: parentNode)
    }
    
    func nodeSize(sprite: SKNode) -> CGSize {
        let spriteCopy = sprite.copy() as! SKNode
        spriteCopy.zRotation = 0
        return spriteCopy.frame.size
    }
  
    func makeSki() -> SKSpriteNode{
        let flatSkiBody = SKPhysicsBody(rectangleOfSize: CGSize(width: SkiGeometry.Length, height: SkiGeometry.Tickness))
        let frontSkiTipBody =  SKPhysicsBody(circleOfRadius: SkiGeometry.TipRadius, center: CGPoint(x: SkiGeometry.Length/2, y: SkiGeometry.TipRadius-SkiGeometry.Tickness/2))
        let backSkiTipBody =  SKPhysicsBody(circleOfRadius: SkiGeometry.TipRadius, center: CGPoint(x: -SkiGeometry.Length/2, y: SkiGeometry.TipRadius-SkiGeometry.Tickness/2))
        let skiBody = SKPhysicsBody(bodies: [backSkiTipBody, flatSkiBody, frontSkiTipBody])
        
      
        let skiNode = SKSpriteNode(color: SKColor.cyanColor(), size: CGSize(width: SkiGeometry.Length, height: SkiGeometry.Tickness))
        skiNode.physicsBody = skiBody
        
        return skiNode
    }
  
    
}