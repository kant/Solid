//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import SceneKit
import RealityKit
import SpriteKit
import ModelIO
import SwiftUI

enum LightingSetup {
    case standard
}

class ViewportModel: NSObject, ObservableObject, SCNSceneRendererDelegate {
    private var scene = SCNScene()
    var cameraNode = SCNNode()
    
    var capture: Capture?
    private var captureNode: SCNNode?
    
    private var previousCapture: Capture?
    
    private var colorScheme: ColorScheme = .dark
    private var backgroundColor: CGColor {
        switch colorScheme {
        case .light:
            return CGColor(gray: 0.9, alpha: 1)
        case .dark:
            return CGColor(gray: 0.05, alpha: 1)
        @unknown default:
            return CGColor(gray: 0.9, alpha: 1)
        }
    }
    
    //TODO: cache of nodes?
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //debugPrint(cameraNode.rotation)
    }
    
    override init() {
        super.init()
        
        //make & add camera
        let camera = SCNCamera()
        
        camera.grainIntensity = 0.5
        camera.grainIsColored = true
        
        camera.automaticallyAdjustsZRange = true
//        camera.screenSpaceAmbientOcclusionIntensity = 1
        
//        camera.wantsDepthOfField = true
//        camera.focusDistance = 1
//        camera.fStop = 0.5
        cameraNode.camera = camera
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        cameraNode.constraints?.append(
            SCNLookAtConstraint(target: scene.rootNode)
        )
        scene.rootNode.addChildNode(cameraNode)
        
        
        //scene options
        scene.wantsScreenSpaceReflection = true
        
        setupSceneEnviroment()
        setupLights(for: .standard)
    }
    
    func scene(with qualityLevel: PhotogrammetrySession.Request.Detail?, colorScheme: ColorScheme) -> SCNScene {
        //update color scheme
        //self.colorScheme = .dark
        scene.fogColor = backgroundColor
        scene.background.contents = backgroundColor
        
        //remove current capture node
        self.captureNode?.removeFromParentNode()
        
        //return empty scene if no quality selected OR capture is not found
        guard let qualityLevel = qualityLevel, let capture = capture else {
            debugPrint("no quality selected OR no capture found")
            return scene
        }
        
        //ensure that capture isn't same OR the processedFiles aren't the same
        guard
            capture.id != previousCapture?.id ||
            capture.processedFiles != previousCapture?.processedFiles
        else {
            return scene
        }
        previousCapture = capture
        
        //get url and check that file exists
        let url = Storage.url(for: capture, with: qualityLevel)
        guard Storage.fileExists(at: url) else {
            debugPrint("capture file NOT found")
            return scene
        }
        debugPrint("capture file found")
        
        //capture node
        let newNode = SCNReferenceNode(url: url)
        newNode?.load()
        let gZeroNode = newNode?.childNode(withName: "g0", recursively: true)
        gZeroNode?.geometry?.firstMaterial?.lightingModel = .physicallyBased
        
        //add new capture to scene
        captureNode = newNode
        if let captureNode = captureNode {
            scene.rootNode.addChildNode(captureNode)
        }
        
        return scene
    }
    
    
    
    private func setupSceneEnviroment() {
        //fog
        scene.fogDensityExponent = 1
        scene.fogStartDistance = 5
        scene.fogEndDistance = 33
        
        //floor geometry
        let floorGeometry = SCNFloor()
        floorGeometry.reflectivity = 0
        
        //floor node
        let floorNode = SCNNode(geometry: floorGeometry)
        floorNode.position = SCNVector3(0, 0, 0)
        floorNode.opacity = 0.2
        
        //floor material
        let floorMaterial = floorGeometry.firstMaterial
        floorMaterial?.lightingModel = .constant
        
        floorMaterial?.diffuse.contents = NSImage(named: "grid")
        floorMaterial?.diffuse.wrapT = .mirror
        floorMaterial?.diffuse.wrapS = .mirror
        floorMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(200, 200, 1)
        
        //add floor
        scene.rootNode.addChildNode(floorNode)
    }
    
    private func setupLights(for setup: LightingSetup) {
        switch setup {
        case .standard:
//            let light = SCNLight()
//            light.type = .omni
//            light.intensity = 600
//
//            let lightNode = SCNNode()
//            lightNode.light = light
//
//            lightNode.position = SCNVector3(x: 5, y: 5, z: 5)
            
//            scene.rootNode.addChildNode(lightNode)
            
            let sky = NSImage(named: "testGradient")

            scene.lightingEnvironment.contents = sky
            //scene.background.contents = sky
        }
    }
}
