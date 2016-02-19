//
//  GameViewController.swift
//  SkijumpDeluxTerje
//
//  Created by Daniel Haugstvedt on 15/02/16.
//  Copyright (c) 2016 Daniel Haugstvedt. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    private struct GeometryConstants {
        // Logical resolution iPad 768 x 1024 
        // Chose width to be 400 m, Let each pixel be 0.1 m
        // Logical width: width = 4000 = 400 m
        // Logical height(keeping aspect ratio)  768/1024*4000 = 3000 = 300 m
        
        static let HillSize = CGSize(width: 4000, height: 3000)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let scene = TestJumperScene(fileNamed: "TestJumperScene") {
       
          let skView = self.view as! SKView
          skView.showsFPS = true
          skView.showsNodeCount = true
          skView.showsPhysics = true
          
          /* Sprite Kit applies additional optimizations to improve rendering performance */
          skView.ignoresSiblingOrder = true
          
          /* Set the scale mode to scale to fit the window */
          scene.scaleMode = .AspectFill
          
          skView.presentScene(scene)
        }
      
    }

    override func shouldAutorotate() -> Bool {
        return false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
