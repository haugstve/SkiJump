//
//  TestJumperScene.swift
//  SkijumpDeluxTerje
//
//  Created by Daniel Haugstvedt on 19/02/16.
//  Copyright © 2016 Daniel Haugstvedt. All rights reserved.
//


import SpriteKit

protocol CustomNodeEvents {
  func didMoveToScene()
}

struct PhysicsCategory {
    static let Node:UInt32 = 0
    static let Jumpter:UInt32 = 0b1 //1
    static let Hill:UInt32 = 0b100 //2
}

class TestJumperScene: SKScene {

  override func didMoveToView(view: SKView) {
    enumerateChildNodesWithName("//*", usingBlock: {node, _ in
      print("node added")
      if let customNode = node as? CustomNodeEvents {
        customNode.didMoveToScene()
      }
      if let sprite = node as? SKSpriteNode {
        sprite.color = SKColor.greenColor()
      }
    })
  }
    
}