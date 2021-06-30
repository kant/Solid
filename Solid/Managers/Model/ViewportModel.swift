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

class ViewportModel: NSObject, ObservableObject {
    private var scene = SCNScene()
    var cameraNode = SCNNode()
    
    var capture: Capture?
    private var captureNode: SCNNode?
    
    private var previousCapture: Capture?
    
    //TODO: cache of nodes?
    
    override init() {
        super.init()
        
        //make & add camera
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zNear = 0.01
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        cameraNode.constraints?.append(
            SCNLookAtConstraint(target: scene.rootNode)
        )
        scene.rootNode.addChildNode(cameraNode)
        
        
        //scene options
        scene.wantsScreenSpaceReflection = true
        
        setGradientBackground()
    }
    
    func scene(with qualityLevel: PhotogrammetrySession.Request.Detail) -> SCNScene {
        guard let capture = capture else {
            debugPrint("no capture found")
            self.captureNode?.removeFromParentNode()
            return scene
        }
        
        //ensure that capture isn't same OR the processedFiles aren't the same
        guard capture.id != previousCapture?.id || capture.processedFiles != previousCapture?.processedFiles else {
            return scene
        }
        previousCapture = capture
        
        let url = Storage.url(for: capture, with: qualityLevel)
        guard Storage.fileExists(at: url) else {
            debugPrint("capture file NOT found")
            self.captureNode?.removeFromParentNode()
            return scene
        }
        debugPrint("capture file found")
        
        let newNode = SCNReferenceNode(url: url)
        newNode?.load()
        captureNode?.removeFromParentNode()
        captureNode = newNode
        
        guard let captureNode = captureNode else {
            return scene
        }
        scene.rootNode.addChildNode(captureNode)
        
        return scene
    }
    
    static let fromColor = CGColor(gray: 0.9, alpha: 1)
    static let toColor = CGColor(gray: 0.95, alpha: 1)
    
    private func setGradientBackground() {
        let skyBox = CAGradientLayer()
        skyBox.colors = [
            ViewportModel.fromColor,
            ViewportModel.toColor
        ]
        skyBox.frame = CGRect(x: 0, y: 0, width: 512, height: 256)
        
//        let skyBox = MDLSkyCubeTexture(name: "sky",
//                                       channelEncoding: .float16,
//                                       textureDimensions: vector_int2(256, 256),
//                                       turbidity: 0.75,
//                                       sunElevation: 0.5,
//                                       upperAtmosphereScattering: 0.15,
//                                       groundAlbedo: 0.85)
        
//        let skyBox = MDLColorSwatchTexture(
//            colorGradientFrom: ViewportModel.fromColor,
//            to: ViewportModel.toColor,
//            name: "gradient",
//            textureDimensions: vector_int2(2048, 1024)
//        )
        
        scene.background.contents = skyBox
        
        
//        scene.lightingEnvironment.contents = MDLSkyCubeTexture(name: "sky",
//                                                               channelEncoding: .float16,
//                                                               textureDimensions: vector_int2(256, 256),
//                                                               turbidity: 0.75,
//                                                               sunElevation: 0.5,
//                                                               upperAtmosphereScattering: 0.15,
//                                                               groundAlbedo: 0.85)
    }
}
