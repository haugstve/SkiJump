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
  var head: SKSpriteNode!
  
  func didMoveToScene() {
    print("jumper was added and died")
    upperArm = childNodeWithName("upper_arm") as! SKSpriteNode
    head = childNodeWithName("head") as! SKSpriteNode
    
  }
}