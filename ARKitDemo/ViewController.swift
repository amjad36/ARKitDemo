//
//  ViewController.swift
//  ARKitDemo
//
//  Created by Amjad Khan on 30/10/17.
//  Copyright © 2017 HCL. All rights reserved.
//

import UIKit
import ARKit
import FTPopOverMenu_Swift

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        // Configuration for running world tracking
        // Tracking motion and processing image for the view’s content.
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        addBox()
    }
    
    func addBox() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        sceneView.scene.rootNode.addChildNode(boxNode)
    }

}

