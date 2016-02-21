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

var direction = 1

class TestJumperScene: SKScene {

  override func didMoveToView(view: SKView) {
    enumerateChildNodesWithName("//*", usingBlock: {node, _ in
        print("node: \(node.name ?? "no_name") added")
      if let customNode = node as? CustomNodeEvents {
        customNode.didMoveToScene()
      }
    })
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let _ = touches.first {
      var gravity = CGVector(dx: 0.0,dy: -9.8)
      switch direction {
        case 1:
          direction = 2
          gravity = CGVector(dx: 0.0,dy: -9.8)
        case 2:
          direction = 3
          gravity = CGVector(dx: 9.8,dy: 0.0)
        case 3:
          direction = 4
          gravity = CGVector(dx: 0.0,dy: 9.8)
        case 4:
          direction = 1
          gravity = CGVector(dx: -9.8,dy: 0.0)
        default:
          direction = 1
          gravity = CGVector(dx: 0.0,dy: -9.8)
      }
      physicsWorld.gravity = gravity
    }
}
    
}