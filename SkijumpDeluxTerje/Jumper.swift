//
//  Jumper.swift
//  SkijumpDeluxTerje
//
//  Created by Daniel Haugstvedt on 19/02/16.
//  Copyright © 2016 Daniel Haugstvedt. All rights reserved.
//

import SpriteKit

class Jumper: SKSpriteNode, CustomNodeEvents {
  
    var body: SKSpriteNode!
    var upperArm: SKSpriteNode!
    var head: SKSpriteNode!
  
  func didMoveToScene() {
    print("jumper was added and died")
    //body = childNodeWithName("body") as! SKSpriteNode will crash, this node is the body
    upperArm = childNodeWithName("upper_arm") as! SKSpriteNode
    head = childNodeWithName("head") as! SKSpriteNode
    
//    let shoulder = SKPhysicsJointFixed.jointWithBodyA(self.physicsBody!, bodyB: upperArm.physicsBody!, anchor: anchorFromNode(upperArm))
    let shoulder2 = SKPhysicsJointPin.jointWithBodyA(self.physicsBody!, bodyB: upperArm.physicsBody!, anchor: anchorFromNode(upperArm))
    scene?.physicsWorld.addJoint(shoulder2)
    print("anchor point \(anchorFromNode(upperArm))")
    print("upper arm rotation \(upperArm.zRotation)")
     print("size of frame \(upperArm.frame.size)")
     print("size of rotated frame \(nodeSize(upperArm))")
    
  }
    
    func anchorFromNode(sprite: SKNode) -> CGPoint{
        guard let scenOfSprite = sprite.scene else {
            return CGPointZero
        }
        guard let parentNode = sprite.parent else {
            return CGPointZero
        }
        var pointOfJointInParentCoordiantes = sprite.position
        
        pointOfJointInParentCoordiantes += CGPoint(x: -10, y: 5)
        //Angle is relative to parent and the body is tilted
        //pointOfJointInParentCoordiantes += CGPoint(angle: sprite.zRotation) * nodeSize(sprite).height/2
        // 0 is paralell and when the arms are raised in fromt the ange is more than 90 degrees
        return scenOfSprite.convertPoint(pointOfJointInParentCoordiantes, fromNode: parentNode)
    }
    
    func nodeSize(sprite: SKNode) -> CGSize {
        let spriteCopy = sprite.copy() as! SKNode
        spriteCopy.zRotation = 0
        return spriteCopy.frame.size
    }
}