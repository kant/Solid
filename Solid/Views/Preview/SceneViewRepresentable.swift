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
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("lightingEnviroment") var lightingEnviroment = Defaults.lightingEnviroment
    @AppStorage("wantsDOF") var wantsDOF = Defaults.wantsDOF
    @AppStorage("focusDistance") var focusDistance = Defaults.focusDistance
    @AppStorage("enviromentRotation") var enviromentRotation = Defaults.enviromentRotation
    @AppStorage("enviromentBrightness") var enviromentBrightness = Defaults.enviromentBrightness
    
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
    func updatedSceneView() -> SCNView {
        //update capture
        viewportModel.update(withNewCapture: capture, quality: selectedPreviewQuality)
        
        //lightingEnviroment
        viewportModel.setupLightingEnviroment(for: lightingEnviroment)
        
        //DOF
        if let camera = sceneView.pointOfView?.camera {
            //animate DOF state
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            camera.wantsDepthOfField = wantsDOF
            SCNTransaction.commit()
            
            camera.focusDistance = focusDistance
        }
        
        //Brightness Slider
        viewportModel.scene.lightingEnvironment.intensity = enviromentBrightness
        
        //Color Scheme
        viewportModel.colorScheme = colorScheme
        
        return sceneView
    }

    func makeNSView(context: Context) -> NSView {
        //set the scene for the view
        sceneView.scene = viewportModel.scene
        
        //allows camera controll
        sceneView.allowsCameraControl = true
        
        //pass the view to the model
        viewportModel.scnView = sceneView
        
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
