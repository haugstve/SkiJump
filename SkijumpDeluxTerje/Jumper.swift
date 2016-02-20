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
    
    let shoulder = SKPhysicsJointFixed.jointWithBodyA(self.physicsBody!, bodyB: upperArm.physicsBody!, anchor: anchorFromNode(upperArm))
    scene?.physicsWorld.addJoint(shoulder)
    print("\(anchorFromNode(upperArm))")
    
  }
    
    func anchorFromNode(sprite: SKNode) -> CGPoint{
        guard let scenOfSprite = sprite.scene else {
            return CGPointZero
        }
        guard let parentNode = sprite.parent else {
            return CGPointZero
        }
        return scenOfSprite.convertPoint(CGPointZero, fromNode: parentNode)
    }
}