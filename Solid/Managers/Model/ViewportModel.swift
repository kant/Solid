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


class ViewportModel: NSObject, ObservableObject, SCNSceneRendererDelegate {
    
    var scnView: SCNView?
    var scene = SCNScene()
    
    var povCameraNode: SCNNode? {
        return scnView?.pointOfView
    }
    
    private lazy var referenceCameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = referenceCamera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        cameraNode.constraints?.append(
            SCNLookAtConstraint(target: scene.rootNode)
        )
        return cameraNode
    }()
    private var referenceCamera: SCNCamera = {
        let camera = SCNCamera()
        
        camera.zNear = Defaults.zMin
        camera.wantsDepthOfField = UserDefaults.standard.bool(forKey: "wantsDOF")
        camera.fStop = 1
        
        camera.wantsHDR = true
        camera.wantsExposureAdaptation = true
        
        camera.exposureAdaptationDarkeningSpeedFactor = 10
        camera.exposureAdaptationBrighteningSpeedFactor = 10
        
//        camera.bloomThreshold = 0.5
//        camera.bloomBlurRadius = 30
        
        
        return camera
    }()


    var capture: Capture?
    var captureNode: SCNNode?
    
    var floorNode: SCNNode?
    
    var previewQuality: PhotogrammetrySession.Request.Detail?
    
    
    var isBackgroundVisible = UserDefaults.standard.bool(forKey: "isBackgroundVisible") {
        didSet {
            //guard let camera = povCameraNode?.camera else { return }
            //camera.bloomIntensity = isBackgroundVisible ? 0.6 : 0
            floorNode?.isHidden = isBackgroundVisible
        }
    }
//    var colorScheme: ColorScheme = .dark {
//        didSet {
//            scene.fogColor = backgroundColor
//            if !isBackgroundVisible {
//                scene.background.contents = backgroundColor
//            }
//        }
//    }
    private var backgroundColor: CGColor {
//        switch colorScheme {
//        case .light:
//            return CGColor(gray: 0.9, alpha: 1)
//        case .dark:
            return CGColor(gray: 0.05, alpha: 1)
//        @unknown default:
//            return CGColor(gray: 0.9, alpha: 1)
//        }
    }
   
    
    //TODO: cache of nodes?
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //debugPrint(cameraNode.rotation)
    }
    
    override init() {
        super.init()
        
        //camera setup
        scene.rootNode.addChildNode(referenceCameraNode)
        
        //scene options
        setupSceneEnvironment()
        
        //setup lighting environment
        let lightingEnvironmentValue = UserDefaults.standard.integer(forKey: "lightingEnvironment")
        if let lightingEnvironment = LightingEnvironment(rawValue: lightingEnvironmentValue) {
            setupLightingEnvironment(for: lightingEnvironment)
        }
    }
    
    func update(withNewCapture newCapture: Capture, quality: PhotogrammetrySession.Request.Detail) {
        //ensure that capture isn't same OR the processedFiles aren't the same
        guard
            newCapture != capture ||
            quality != previewQuality
        else {
            return
        }
        
        //update local variables
        capture = newCapture
        previewQuality = quality
        guard let capture = capture, let previewQuality = previewQuality else { return }
        

        //get url and check that file exists
        let url = Storage.url(for: capture, with: previewQuality)
        guard Storage.fileExists(at: url) else {
            debugPrint("capture file NOT found")
            self.captureNode?.removeFromParentNode()
            return
        }
        debugPrint("capture file found")
        
        //create capture node
        let newNode = SCNReferenceNode(url: url)
        newNode?.load()
        let gZeroNode = newNode?.childNode(withName: "g0", recursively: true)
        gZeroNode?.geometry?.firstMaterial?.lightingModel = .physicallyBased
        
        //remove current capture node
        self.captureNode?.removeFromParentNode()
        
        //add new capture to scene
        captureNode = newNode
        if let captureNode = captureNode {
            scene.rootNode.addChildNode(captureNode)
        }
    }
 
    
    private func setupSceneEnvironment() {
        //reflections
        scene.wantsScreenSpaceReflection = true
        
        //fog
        scene.fogColor = backgroundColor
        scene.fogDensityExponent = 1
        scene.fogStartDistance = 5
        scene.fogEndDistance = 33
        
        
        //floor geometry
        let floorGeometry = SCNFloor()
        floorGeometry.reflectivity = 0
        
        //floor node
        floorNode = SCNNode(geometry: floorGeometry)
        floorNode?.position = SCNVector3(0, -0.5, 0)
        floorNode?.opacity = 0.2
        
        //floor material
        let floorMaterial = floorGeometry.firstMaterial
        floorMaterial?.lightingModel = .constant
        
        floorMaterial?.diffuse.contents = NSImage(named: "grid")
        floorMaterial?.diffuse.wrapT = .mirror
        floorMaterial?.diffuse.wrapS = .mirror
        floorMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(50, 50, 1)
        
        //add floor
        if let floorNode = floorNode {
            scene.rootNode.addChildNode(floorNode)
        }
    }
    
    func setupLightingEnvironment(for style: LightingEnvironment) {
        //cube
//        var sky: [NSImage] = []
//        for index in 0...5 {
//            if let image = NSImage(named: "light_\(style.rawValue)_0000\(index).exr") {
//                sky.append(image)
//            }
//        }
        
        let imageName = "environment_\(style.rawValue)"
        scene.lightingEnvironment.contents = imageName
        
        //sky
        if isBackgroundVisible {
            scene.background.contents = imageName
        } else {
            scene.background.contents = backgroundColor
        }
    }
    
    
    func resetFrame() { //completion: (() -> Void)? = nil
        guard let captureNode = captureNode else { return }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        
        povCameraNode?.position = SCNVector3(x: 0, y: 0, z: 2)
        povCameraNode?.rotation = SCNVector4(x: 0, y: 0, z: 0, w: 0)
        povCameraNode?.look(at: captureNode.worldPosition)
        
        //SCNTransaction.completionBlock = completion
        
        SCNTransaction.commit()
    }
    
}
