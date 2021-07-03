//
//  SceneViewRepresentable.swift
//  Solid
//
//  Created by Andrew Sawyer on 7/2/21.
//

import Foundation
import SwiftUI
import SceneKit
import RealityKit
import RealmSwift

struct SceneViewRepresentable: NSViewRepresentable {
    
    var viewportModel: ViewportModel
    @ObservedRealmObject var capture: Capture
    
    let sceneView = SCNView()
    
    //@Environment(\.colorScheme) var colorScheme
    
    @AppStorage("lightingEnvironment") var lightingEnvironment = Defaults.lightingEnvironment
    @AppStorage("isBackgroundVisible") var isBackgroundVisible = Defaults.isBackgroundVisible
    @AppStorage("wantsDOF") var wantsDOF = Defaults.wantsDOF
    @AppStorage("focusDistance") var focusDistance = Defaults.focusDistance
    @AppStorage("environmentRotation") var environmentRotation = Defaults.environmentRotation
    
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
    func updatedSceneView() -> SCNView {
        //update capture
        viewportModel.update(withNewCapture: capture, quality: selectedPreviewQuality)
        
        //lightingEnvironment
        viewportModel.isBackgroundVisible = isBackgroundVisible
        viewportModel.setupLightingEnvironment(for: lightingEnvironment)
        
        //DOF
        if let camera = sceneView.pointOfView?.camera {
            //animate DOF state
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            camera.wantsDepthOfField = wantsDOF
            SCNTransaction.commit()
            
            camera.focusDistance = focusDistance
        }
        
        //Environment Rotation
        let radianRotation = environmentRotation * 2 * CGFloat.pi
        //viewportModel.scene.rootNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: radianRotation)
        viewportModel.captureNode?.rotation = SCNVector4(x: 0, y: 1, z: 0, w: radianRotation)
        
        //Color Scheme
        //viewportModel.colorScheme = colorScheme
        
        return sceneView
    }

    func makeNSView(context: Context) -> NSView {
        //set the scene for the view
        sceneView.scene = viewportModel.scene
        
        //allows camera controll
        sceneView.allowsCameraControl = true
        
        //pass the view to the model
        viewportModel.scnView = sceneView
        
        viewportModel.setupLightingEnvironment(for: lightingEnvironment)
        
        return updatedSceneView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        let _ = updatedSceneView()
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject {
//        var parent: SceneViewRepresentable
//
//        init(_ sceneViewRepresentable: SceneViewRepresentable) {
//            parent = sceneViewRepresentable
//        }
//    }
}
