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

struct MyCameraCoordinates {
    var x = Float()
    var y = Float()
    var z = Float()
}

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var btnPlus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureLighting()
        addTapGesture()
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
    
    @IBAction func plusButtonPressed(_ sender: Any, event: UIEvent) {
        
        FTPopOverMenu.showForEvent(event: event, with: ["Plane", "Car", "Cube"], menuImageArray: [""], done: { (selectedIndex) in
            switch (selectedIndex) {
            case 0:
                let cc = self.getCameraCoordinates(sceneView: self.sceneView)
                self.addPaperPlane(x: cc.x, y: cc.y, z: cc.z)
            case 1:
                let cc = self.getCameraCoordinates(sceneView: self.sceneView)
                self.addCar(x: cc.x, y: cc.y, z: cc.z)
            case 2:
                let cc = self.getCameraCoordinates(sceneView: self.sceneView)
                self.addBox(x: cc.x, y: cc.y, z: cc.z)
            default:
                print("cancelled")
            }
        }) {
            print("cancelled")
        }
    }
    
    
    //MARK: Custom functions
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addPaperPlane(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let paperPlaneScene = SCNScene(named: "paperPlane.scn"), let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: "paperPlane", recursively: true) else { return }
        paperPlaneNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(paperPlaneNode)
    }
    
    func addCar(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        guard let carScene = SCNScene(named: "car.dae") else { return }
        let carNode = SCNNode()
        
        for childNode in carScene.rootNode.childNodes {
            carNode.addChildNode(childNode)
        }
        
        carNode.position = SCNVector3(x, y, z)
        carNode.scale = SCNVector3(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(carNode)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(tapLocation)
        guard let node = hitTestResult.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoint = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoint.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
    
    func randomFlot(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> MyCameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = MyCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(x: translation.x, y: translation.y, z: translation.z)
    }
}
