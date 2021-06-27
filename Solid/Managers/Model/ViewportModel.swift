//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import SceneKit
//import SceneKit.ModelIO
import RealityKit

class ViewportModel: NSObject, ObservableObject {
    var scene = SCNScene()
    var cameraNode = SCNNode()
    
    var capture: Capture?
    var captureNode: SCNNode?
    
    //TODO: cache of nodes?
    
    override init() {
        super.init()
        
        //make & add camera
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        setGradientBackground()
    }
    
    func scene(with qualityLevel: PhotogrammetrySession.Request.Detail) -> SCNScene {
        
        guard let url = capture?.url(for: qualityLevel) else { return scene }
        let newNode = SCNReferenceNode(url: url)
        newNode?.load()
        captureNode?.removeFromParentNode()
        captureNode = newNode
        
        guard let captureNode = captureNode else { return scene }
        scene.rootNode.addChildNode(captureNode)
        
        return scene
    }
    
    private func setGradientBackground() {
        scene.background.contents = CGColor(red: 1, green: 0.2, blue: 0, alpha: 1)
    }
}
