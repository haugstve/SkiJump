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
    var ski: SKSpriteNode!
    
    var head: SKSpriteNode!
  
  func didMoveToScene() {
    //body = childNodeWithName("body") as! SKSpriteNode will crash, this node is the body
    
    upperArm = childNodeWithName("upper_arm") as! SKSpriteNode
    lowerArm = childNodeWithName("//lower_arm") as! SKSpriteNode
    hand = childNodeWithName("//hand") as! SKSpriteNode
    
    upperLeg = childNodeWithName("upper_leg") as! SKSpriteNode
    lowerLeg = childNodeWithName("//lower_leg") as! SKSpriteNode
    foot = childNodeWithName("//foot") as! SKSpriteNode
    ski = childNodeWithName("//ski") as! SKSpriteNode
    
    head = childNodeWithName("head") as! SKSpriteNode
    

    let shoulder = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: upperArm.physicsBody!, anchor: anchorFromNode(upperArm))
    let elbow = SKPhysicsJointPin.jointWithBodyA(upperArm.physicsBody!, bodyB: lowerArm.physicsBody!, anchor: anchorFromNode(lowerArm))
    let wrist = SKPhysicsJointPin.jointWithBodyA(lowerArm.physicsBody!, bodyB: hand.physicsBody!, anchor: anchorFromNode(hand))
    
    let hipp = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: upperLeg.physicsBody!, anchor: anchorFromNode(upperLeg))
    let knee = SKPhysicsJointPin.jointWithBodyA(upperLeg.physicsBody!, bodyB: lowerLeg.physicsBody!, anchor: anchorFromNode(lowerLeg))
    let ancle = SKPhysicsJointPin.jointWithBodyA(lowerLeg.physicsBody!, bodyB: foot.physicsBody!, anchor: anchorFromNode(foot))
    
    let neck = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: head.physicsBody!, anchor: scene!.convertPoint(head.position, fromNode: self))
    
    lockJoint(shoulder)
    lockJoint(elbow)
    lockJoint(wrist)
    
    lockJoint(hipp)
    lockJoint(knee)
    lockJoint(ancle)
    
    lockJoint(neck)
    
    
    scene?.physicsWorld.addJoint(shoulder)
    scene?.physicsWorld.addJoint(elbow)
    scene?.physicsWorld.addJoint(wrist)
    
    scene?.physicsWorld.addJoint(hipp)
    scene?.physicsWorld.addJoint(knee)
    scene?.physicsWorld.addJoint(ancle)
    
    scene?.physicsWorld.addJoint(neck)
    
  }
  
  func lockJoint(joint: SKPhysicsJointPin) {
    joint.shouldEnableLimits = true
    joint.upperAngleLimit = CGFloat(5).degreesToRadians()
    joint.lowerAngleLimit = -CGFloat(5).degreesToRadians()
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
}